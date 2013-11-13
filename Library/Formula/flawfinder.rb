require 'formula'

class Flawfinder < Formula
  homepage 'http://www.dwheeler.com/flawfinder/'
  url 'http://www.dwheeler.com/flawfinder/flawfinder-1.27.tar.gz'
  sha1 '0af702c1e0cbd0385a78be6ef1f2f7752ba6193f'
  head 'git://git.code.sf.net/p/flawfinder/code'

  def install
    system "make", "INSTALL_DIR=#{prefix}",
                   "INSTALL_DIR_BIN=#{bin}",
                   "INSTALL_DIR_MAN=#{man1}",
                   "install"
  end
end
