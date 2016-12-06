require 'formula'

class Cgminer < Formula
  url 'http://dl.dropbox.com/u/125278/Code/cgminer-1.2.4-osx-src.tar.bz2'
  version '1.2.4-osx'
  homepage 'https://github.com/ckolivas/cgminer'
  sha256 'e2dfd281c135f133aec997678591c8ce78081a9db06921aa2de58936812fb8db'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
