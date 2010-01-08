require 'formula'

class Whohas <Formula
  url 'http://www.philippwesche.org/200811/whohas/whohas-0.23.tar.gz'
  homepage 'http://www.philippwesche.org/200811/whohas/intro.html'
  md5 '0895fb6353950fe2e686fa867aaf0416'

  def install
    bin.install 'program/whohas'
    man1.install 'usr/share/man/man1/whohas.1'
    (share+'whohas').install 'intro.txt'
  end
end
