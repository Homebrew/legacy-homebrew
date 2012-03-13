require 'formula'

class Mailcheck < Formula
  url 'http://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz'
  homepage 'http://mailcheck.sourceforge.net/'
  md5 'd2a3a22a65b1006d213d8cb3f4738070'

  def install
    system "make mailcheck"
    bin.install 'mailcheck'
    man1.install 'mailcheck.1'
    etc.install 'mailcheckrc'
  end
end
