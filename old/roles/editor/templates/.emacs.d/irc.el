(require 'tls)
(add-hook 'erc-after-connect
	  '(lambda (SERVER NICK)
    	     (cond
    	      ((string-match "freenode\\.net" SERVER)
    	       (erc-message "PRIVMSG" "NickServ identify Qwattash[Freenode92]"))
    
    	      ((string-match "irc.srcf.ucam.org" SERVER)
    	       (erc-message "PRIVMSG" "NickServ identify Qwattash[cam92]"))
	      )))

(require 'erc-join)
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
      '(("irc.srcf.ucam.org" "#ctsrd")))

(defun start-irc ()
  "Connect to IRC."
  (interactive)
  (erc-tls :server "irc.srcf.ucam.org" :port 6697
	   :nick "qwattash" :full-name "Alfredo Mazzinghi")
  (erc-tls :server "chat.freenode.net" :port 6697
	   :nick "qwattash" :full-name "qwattash"))
