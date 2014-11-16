require 'formula'

class PutmailQueue < Formula
  homepage 'http://putmail.sourceforge.net/home.html'
  url 'https://downloads.sourceforge.net/project/putmail/putmail-queue/0.2/putmail-queue-0.2.tar.bz2'
  sha1 '55eca5d8cdeec7f742b3ac5839a266120e50d176'

  depends_on 'putmail'

  def install
    bin.install 'putmail_dequeue.py', 'putmail_enqueue.py'
    man1.install Dir["man/man1/*.1"]
  end
end
