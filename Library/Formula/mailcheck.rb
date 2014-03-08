require 'formula'

class Mailcheck < Formula
  homepage 'http://mailcheck.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz'
  sha1 '62909555f1afcb411fe097fce6595889dd2c5bcf'

  def install
    system "make mailcheck"
    bin.install 'mailcheck'
    man1.install 'mailcheck.1'
    etc.install 'mailcheckrc'
  end
end
