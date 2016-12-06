require 'formula'

class Fishfish < Formula
  homepage 'http://ridiculousfish.com/shell/'
  version 'beta-r2'
  url 'http://ridiculousfish.com/shell/files/fishfish.tar.gz'
  sha1 'eaf37b356cbbc48ebb4157514d3d98d08a37d86e'
  head 'https://github.com/fish-shell/fish-shell.git'

  depends_on "doxygen"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def test
    system "fishfish"
  end
end
