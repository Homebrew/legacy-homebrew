require 'formula'

class Fishfish < Formula
  homepage 'http://ridiculousfish.com/shell/beta.html'
  url 'http://ridiculousfish.com/shell/files/fishfish.tar.gz'
  sha1 'eaf37b356cbbc48ebb4157514d3d98d08a37d86e'
  version '1.23.1'

  def install

    system "autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-xsel"
    system "make"
    system "make install"
  end

  def test
    system "fish -v"
  end
end
