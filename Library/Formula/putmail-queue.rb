require 'formula'

class PutmailQueue < Formula
  url 'http://downloads.sourceforge.net/project/putmail/putmail-queue/0.2/putmail-queue-0.2.tar.bz2'
  homepage 'http://putmail.sourceforge.net/home.html'
  md5 '8c9401e403bd6d0948e8cbcfc811f1db'

  depends_on 'putmail.py'

  def install
    bin.install ['putmail_dequeue.py', 'putmail_enqueue.py']
    share.install 'man'
    (prefix+'share/doc/putmail-queue').install ['doc/AUTHORS', 'doc/LICENSE', 'doc/README']
  end
end
