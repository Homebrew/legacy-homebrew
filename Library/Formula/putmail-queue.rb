class PutmailQueue < Formula
  desc "Putmail queue package"
  homepage "http://putmail.sourceforge.net/home.html"
  url "https://downloads.sourceforge.net/project/putmail/putmail-queue/0.2/putmail-queue-0.2.tar.bz2"
  sha256 "09349ad26345783e061bfe4ad7586fbbbc5d1cc48e45faa9ba9f667104f9447c"

  bottle :unneeded

  depends_on "putmail"

  def install
    bin.install "putmail_dequeue.py", "putmail_enqueue.py"
    man1.install Dir["man/man1/*.1"]
  end
end
