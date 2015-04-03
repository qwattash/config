""" Test the gen screen parser
"""

import unittest

from unittest import mock

from gen_screen import *

class TestParserNewRowState(unittest.TestCase):

    def setUp(self):
        user_args = mock.Mock()
        user_args.separator = "<>"
        user_args.limit = 200
        self.state = NewRowState(user_args)

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_transition_on_input(self, mock_receive):
        data = "sample " * 10
        self.state.receive(data)
        # check that a new row is created and a switch to NewBlockState has happened
        self.assertEqual(self.state.__class__, NewBlockState)
        # a row was created
        self.assertEqual(len(self.state.issue.rows), 1)
        self.assertIsNotNone(self.state.row)
        # no block in the row
        self.assertEqual(len(self.state.row.blocks), 0)
        self.assertIsNone(self.state.block)
        # receive is chained to the new state
        mock_receive.assert_called_once_with(data)

    @mock.patch("gen_screen.IssueFileEndState.receive")
    def test_transition_on_separator(self, mock_receive):
        data = "<>" + "sample " * 10
        self.state.receive(data)
        # check that a new row is created and a switch to IssueFileEndState has happened
        self.assertEqual(self.state.__class__, IssueFileEndState)
        self.assertFalse(mock_receive.called)
        self.assertEqual(len(self.state.issue.rows), 0)
        self.assertIsNone(self.state.row)

        
class TestParserNewBlockState(unittest.TestCase):
    
    def setUp(self):
        user_args = mock.Mock()
        user_args.separator = "<>"
        user_args.limit = 200
        self.row = mock.Mock()
        self.state = NewBlockState(user_args)
        self.state.issue.add_row(self.row)

    @mock.patch("gen_screen.BlockInputState.receive")
    def test_transition_on_input(self, mock_receive):
        data = "sample " * 10
        self.state.receive(data)
        # check that a new row is created and a switch to NewBlockState has happened
        self.assertEqual(self.state.__class__, BlockInputState)
        # receive is chained to the new state
        mock_receive.assert_called_once_with(data)
        # a block was appended to the row
        self.assertTrue(self.row.append.called)

    @mock.patch("gen_screen.NewRowState.receive")
    def test_transition_on_separator(self, mock_receive):
        data = "sample " * 10
        full_data = "<>" + data
        self.state.receive(full_data)
        # check that the block is created and a switch to IssueFileEndState has happened
        self.assertEqual(self.state.__class__, NewRowState)
        # the row receive the data input
        mock_receive.assert_called_once_with(data)
        # nothing was appended to the row
        self.assertFalse(self.row.append.called)


class TestParserInputBlockState(unittest.TestCase):

    def setUp(self):
        user_args = mock.Mock()
        user_args.separator = "<>"
        user_args.limit = 200
        self.row = Row(200, 0, 0)
        self.block = Block()
        self.state = BlockInputState(user_args)
        self.state.issue.add_row(self.row)
        self.state.row.append(self.block)
        
    def test_normal_input(self):
        self.state.receive("line 1")
        self.state.receive("line 2")
        self.state.receive("line 3 with some more data")
        # no transition occurred
        self.assertEqual(self.state.__class__, BlockInputState)
        # 3 lines of data in the block
        self.assertEqual(self.block.height, 3)
        self.assertEqual(self.block.data[0], "line 1")
        self.assertEqual(self.block.data[1], "line 2")
        self.assertEqual(self.block.data[2], "line 3 with some more data")

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_new_block_transition_start_sep(self, mock_recv):
        # transition with string starting with separator
        data = "data " * 10
        full_data = "<>" + data
        self.state.receive(full_data)
        # transition occurred
        self.assertEqual(self.state.__class__, NewBlockState)
        # next state called
        mock_recv.assert_called_once_with(data)

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_new_block_transition_end_sep(self, mock_recv):
        # transition with string ending with separator
        data = "data " * 10
        full_data = data + "<>"
        self.state.receive(full_data)
        # transition occurred
        self.assertEqual(self.state.__class__, NewBlockState)
        # next state called
        self.assertFalse(mock_recv.called)
        # previous text appended to block
        self.assertEqual(len(self.block.data), 1)
        self.assertEqual(self.block.data[0], data)

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_new_block_transition_mid_sep(self, mock_recv):
        # transition with string with separator somewhere inside
        data1 = "data 1" * 8
        data2 = "data 2" * 8
        full_data = data1 + "<>" + data2
        self.state.receive(full_data)
        # transition occurred
        self.assertEqual(self.state.__class__, NewBlockState)
        # previous text appended to block
        self.assertEqual(len(self.block.data), 1)
        self.assertEqual(self.block.data[0], data1)
        # extra text passed to next receive
        mock_recv.assert_called_once_with(data2)

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_new_row_transition_start_sep(self, mock_recv):
        # transition with string starting with separator
        data = "data " * 10
        full_data = "<><>" + data
        self.state.receive(full_data)
        # transition occurred
        self.assertEqual(self.state.__class__, NewBlockState)
        # next state called
        mock_recv.assert_called_once_with("<>" + data)

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_new_row_transition_end_sep(self, mock_recv):
        # transition with string starting with separator
        data = "data " * 10
        full_data = data + "<><>"
        self.state.receive(full_data)
        # transition occurred
        self.assertEqual(self.state.__class__, NewBlockState)
        # next state called
        mock_recv.assert_called_once_with("<>")
        # previous text appended to block
        self.assertEqual(len(self.block.data), 1)
        self.assertEqual(self.block.data[0], data)

    @mock.patch("gen_screen.NewBlockState.receive")
    def test_new_row_transition_mid_sep(self, mock_recv):
        # transition with string with separator somewhere inside
        data1 = "data 1" * 8
        data2 = "data 2" * 8
        full_data = data1 + "<><>" + data2
        self.state.receive(full_data)
        # transition occurred
        self.assertEqual(self.state.__class__, NewBlockState)
        # previous text appended to block
        self.assertEqual(len(self.block.data), 1)
        self.assertEqual(self.block.data[0], data1)
        # extra text passed to next receive
        mock_recv.assert_called_once_with("<>" + data2)

    @mock.patch("gen_screen.NewRowState.receive")
    def test_block_overflow_transition(self, mock_recv):
        # add a block that spans almost the whole row
        data_row_1 = "a" * 180
        block = Block()
        block.append(data_row_1)
        self.state.issue.rows[0].blocks.insert(0, block)
        # add block that overflows
        data_row_2_initial = "b" * 10
        data_row_2_overflow = "c" * 180
        self.state.receive(data_row_2_initial)
        self.state.receive(data_row_2_overflow)
        # transition occurred
        self.assertEqual(self.state.__class__, NewRowState)
        # previous text appended to block
        self.assertEqual(len(self.state.issue.rows), 1)
        self.assertEqual(len(self.state.issue.rows[0].blocks), 1)
        self.assertEqual(len(self.state.issue.rows[0].blocks[0].data), 1)
        self.assertEqual(self.state.issue.rows[0].blocks[0].data[0], data_row_1)
        # check calls to build second row again
        mock_recv.assert_has_calls([mock.call(data_row_2_initial),
                                    mock.call(data_row_2_overflow)])

    @mock.patch("gen_screen.NewRowState.receive")
    def test_row_overflow_transition(self, mock_recv):
        data_row_2_overflow = "c" * 210
        self.state.receive(data_row_2_overflow)
        # transition occur
        self.assertEqual(self.state.__class__, NewBlockState)
        # previous text block removed
        self.assertEqual(len(self.state.issue.rows), 1)
        self.assertEqual(len(self.state.issue.rows[0].blocks), 0)
        # check calls to build second row again
        self.assertFalse(mock_recv.called)
    
if __name__ == "__main__":
    unittest.main()
