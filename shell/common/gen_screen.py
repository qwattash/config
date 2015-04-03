#!/bin/python

# this is built for python 3
# deal with it

import argparse
import sys
import re

# enable debug output
DEBUG = False

# terminal escape sequences
term_esc = re.compile("\x1b\[[0-9;]*m")

class Block:
    """
    :class: Represent a single block that will be appended at the end of a row
    :attribute data list: List of lines in the block
    :attribute pad_x int: Horizontal padding
    :attribute pad_y int: Vertical padding
    """

    def __init__(self, pad_x=0, pad_y=0):
        """
        :param pad_x int: default 0, the horizontal padding to add
        :param pad_y int: default 0, the vertical padding to add
        """
        self.data = []
        self.pad_x = pad_x
        self.pad_y = pad_y

    def append(self, line):
        """ Append a line to the block
        :param line str: The line to be added
        """
        line = line.rstrip("\n")
        self.data.append(line)

    def draw(self, index):
        """ Draw the line at index for the block
        :param index int: the line index
        """
        if index < self.pad_y:
            # if the index points to one of the padding rows, give an empty line
            return " " * self.width
        try:
            index -= self.pad_y
            # otherwise try to return a line padded horizontally to the width of the block
            content = " " * self.pad_x
            raw_line = self.data[index]
            true_line = term_esc.sub("", raw_line)
            padding = self.width - len(true_line)
            content += raw_line
            if padding > 0:
                content += " " * padding
            return content
        except IndexError:
            return " " * self.width

    def __iter__(self):
        """ Iterate over lines
        """
        for line in self.data:
            yield line
    
    def __len__(self):
        """ Get the maximum length of the block, correspond to the bounding box width
        The lenght includes the padding but filters out the terminal escapes
        """
        longest = 0
        for line in self.data:
            true_line = term_esc.sub("", line)
            if len(true_line) > longest:
                longest = len(true_line)
        longest += 2 * self.pad_x
        return longest

    @property
    def width(self):
        """ Return the block width
        :return int: the width in columns
        """
        return len(self)

    @property
    def height(self):
        """ Return the block height
        :return int: the height in rows
        """
        return len(self.data) + self.pad_y
    

class Row:
    """ A row in the output file
    :class: The row is opaque, except for providing a way to append a block to the end of the row
    :attribute limit int: Maximum row width, including spacing
    :attribute spacing int: Spacing between blocks in a row
    :attribute blocks list: List of blocks in the row
    """

    @classmethod
    def from_args(cls, args):
        """ Create Row from parameters
        :param args Namespace: the ArgumentParser output
        :return: a Row instance
        """
        return cls(args.limit, args.h_spacing, args.v_spacing)

    def __init__(self, limit, h_spacing, v_spacing):
        """
        :param data: the data byte strings for the row
        :param limit int: the columns limit (number of chars) for the row
        :param h_spacing int: horizontal spacing for the next item in the row
        :param v_spacing int: vertical spacing for the next row
        """
        self.blocks = []
        self.limit = limit
        self.h_spacing = h_spacing
        self.v_spacing = v_spacing

    @property
    def block(self):
        """ the currently edited block
        :return Block:
        """
        if len(self.blocks) > 0:
            return self.blocks[-1]
        return None

    @property
    def width(self):
        """ Return the row width
        :return int: the width in columns
        """
        return len(self)

    @property
    def height(self):
        """ Return the row height
        :return int: the height in rows
        """
        try:
            return max([b.height for b in self.blocks])
        except ValueError:
            # emtpy row
            return 0

    def append(self, block):
        """
        Append a block to the row
        :param block Block: the block to be appended
        :raises ValueError: when the block makes the row overflow the limit
        """
        if len(self) + len(block) + self.h_spacing > self.limit:
            raise ValueError("The block causes overflow")
        self.blocks.append(block)

    def __len__(self):
        row_length = sum(map(lambda b: b.width, self.blocks)) + len(self.blocks) * self.h_spacing
        return row_length

    def draw(self, out):
        """ Draw the whole file to the given file like object
        :param out file: The output file like object
        """
        if len(self.blocks) == 0:
            return
        # get highest block
        max_height = max(map(lambda b: b.height, self.blocks))
        for line in range(0, max_height):
            content = ""
            for idx, block in enumerate(self.blocks):
                content += block.draw(line)
                # only add spacing if the block is not the frist or the last one
                if idx < len(self.blocks) - 1:
                    content += " " * self.h_spacing
            content += "\n"
            out.write(content)
        # write the row spacing
        for pad in range(0, self.v_spacing):
            out.write("\n")
            

class IssueFile:
    """ The issue file representation
    :class: Represent the file as a collection of rows
    :attribute rows list: list of Row objects
    """

    def __init__(self):
        self.rows = []

    @property
    def row(self):
        """ the currently edited row
        :return Row:
        """
        if len(self.rows) > 0:
            return self.rows[-1]
        return None

    def append(self, block):
        """ Append block to current row
        :param block Block: The block to append
        """
        current_row = self.rows[-1]
        try:
            current_row.append(block)
        except ValueError:
            print(len(current_row), len(block))
            self.add_row(Row(current_row.limit, current_row.h_spacing, current_row.v_spacing))
            self.rows[-1].append(block)

    def add_row(self, row):
        """ Add new row to the file
        :param row Row: the row to be added
        """
        self.rows.append(row)

    def draw(self, out):
        """ Draw the whole file to the given file like object
        :param out file: The output file like object
        """
        for row in self.rows:
            row.draw(out)

            
class BaseIssueGenerator:
    """ Base state pattern generator
    :class:
    :attribute issue IssueFile: the current issue file instance
    :attribute separator str: the block separator sequence
    :attribute user_args Namespace: argparse output for user parameters
    :attribute limit int: row width limit
    """

    def __init__(self, user_args):
        """
        :param user_args Namespace: argparse output for user parameters
        """
        self.issue = IssueFile()
        self.separator = user_args.separator
        self.user_args = user_args
        self.limit = user_args.limit

    @property
    def row(self):
        """ the row currently being composed
        :return Row: 
        """
        return self.issue.row

    @property
    def block(self):
        """ the block currently being composed
        :return Block:
        """
        return self.row.block

    @property
    def is_finished(self):
        """ check whether the parsing have finished
        :return bool: True if the parsing ended
        """
        return False

    def receive(self, data):
        """ Receive data from input
        :param data str: the input data line
        """
        pass

    def switch(self, state):
        """ Switch state to the given one
        :param state BaseIssueGenerator: the next state to set
        """
        if DEBUG:
            print("[+] switch state {0} -> {1}".format(type(self), state))
        self.__class__ = state

        
class NewRowState(BaseIssueGenerator):
    """ Add a new row as soon as new input comes
    This is the initial state.
    After the row is added the state is switched and the input is given to the new state
    that should handle it.
    :class:
    """

    def receive(self, data):
        """
        Valid inputs are:
        * a string starting with a separator sequence -> IssueFileEndState
        * a string with data -> NewBlockState
        """
        if DEBUG:
            print("[+] {0} recv <= '{1}'".format(type(self), data))
        if data.startswith(self.separator):
            self.switch(IssueFileEndState)
        elif len(data) > 0:
            self.issue.add_row(Row.from_args(self.user_args))
            self.switch(NewBlockState)
            self.receive(data)

            
class NewBlockState(BaseIssueGenerator):
    """ Add new block to the current row and switch to the input state
    -> BlockInputState
    -> NewRowState
    :class:
    """

    def receive(self, data):
        """ 
        Valid inputs are:
        * any string -> create block and go to BlockInputState
        * separator -> go to NewRowState directly
        """
        if DEBUG:
            print("[+] {0} recv <= '{1}'".format(type(self), data))
        if data.startswith(self.separator):
            self.switch(NewRowState)
            data = re.sub("^{0}".format(self.separator), "", data, count=1)
            self.receive(data)
        elif len(data) > 0:
            kwargs = {}
            if len(self.issue.rows) == 1:
                # if the block goes in the first row
                kwargs["pad_y"] = self.user_args.pad_top
            if self.row is not None and self.row.height == 0:
                # first column for the row
                kwargs["pad_x"] = self.user_args.pad_left
            self.row.append(Block(**kwargs))
            self.switch(BlockInputState)
            self.receive(data)
            

class BlockInputState(BaseIssueGenerator):
    """ State that appends
    :class:
    """

    def receive(self, data):
        """
        Valid inputs are:
        * a string starting with a separator sequence -> NewBlockState
        * a string with data -> BlockInputState
        """
        if DEBUG:
            print("[+] {0} recv <= '{1}'".format(type(self), data))
        if data.startswith(self.separator):
            # switch state if the string begins with a separator
            self.switch(NewBlockState)
            data = re.sub("^{0}".format(self.separator), "", data, count=1)
            self.receive(data)
        elif len(data) > 0:
            # check if there are multiple separators in the data
            match = re.match("(.*?)({0})(.*)".format(self.separator), data)
            if match:
                # if there are separators, append everything until the first one and
                # then delegate to the receive funcion recursively,
                # which will go to NewBlockState
                block_data = match.group(1)
                self.block.append(block_data)
                self.switch(NewBlockState)
                if match.group(3) != "":
                    self.receive(match.group(3))
            else:
                # if no separators are in the line received, append the line directly
                self.block.append(data)
        # check row limit
        if self.row.width > self.limit:
            # limit violation, check if we can fix by moving the last block to a new row
            if self.block.width > self.limit:
                # we appended a row longer than the limit, splitting is useless
                # just return silently instead of raising an exception
                if DEBUG:
                    print("Block width limit exceeded: {0}/{1}".format(
                        self.block.width,
                        self.limit))
                # restart from clean block
                self.row.blocks.remove(self.block)
                self.switch(NewBlockState)
                return
            # the row is safe to split
            blk = self.block
            self.row.blocks.remove(blk)
            self.switch(NewRowState)
            for line in blk:
                self.receive(line)
                

class IssueFileEndState(BaseIssueGenerator):
    """ Does not append anything to the file
    This changes the finished status of the parser
    """

    @property
    def is_finished(self):
        return True
        
            
if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Create and manage an issue file suitable to be printed on terminals.")
    parser.add_argument("-c",
                        dest="h_spacing",
                        default=10,
                        type=int,
                        help="Spacing of columns inside a row, half of this is used as border margin before the first column")
    parser.add_argument("-r",
                        dest="v_spacing",
                        default=2,
                        type=int,
                        help="Vertical spacing between rows, half of this is used as border margin before the first row")
    parser.add_argument("-t",
                        dest="pad_top",
                        type=int,
                        help="Top padding for the first row")
    parser.add_argument("-l",
                        dest="pad_left",
                        type=int,
                        help="Left padding for the first column")
    parser.add_argument("-o",
                        dest="output",
                        help="Output file name")
    parser.add_argument("-s",
                        dest="separator",
                        required=True,
                        help="Block separator sequence")
    parser.add_argument("-d",
                        dest="debug",
                        action='store_true',
                        help="Verbose, print debug output")
    parser.add_argument("-m",
                        dest="limit",
                        default=80,
                        type=int,
                        help="Row width limit, if a row exceeds the limit the block will wrap below")

    # parse the arguments
    args = parser.parse_args()
    # debug mode
    DEBUG = args.debug
    issue_parser = NewRowState(args)
    while not issue_parser.is_finished:
        data = sys.stdin.readline()
        data = data.strip("\n")
        issue_parser.receive(data)
    # output data
    issue_parser.issue.draw(sys.stdout)
