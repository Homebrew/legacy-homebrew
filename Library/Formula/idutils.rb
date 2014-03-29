require 'formula'

class Idutils < Formula
  homepage 'http://www.gnu.org/s/idutils/'
  url 'http://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz'
  sha256 '8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2'

  conflicts_with 'coreutils', :because => 'both install `gid` and `gid.1`'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
