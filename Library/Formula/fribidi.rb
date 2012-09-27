require 'formula'

class Fribidi < Formula
  url 'http://fribidi.org/download/fribidi-0.19.2.tar.gz'
  sha1 '3889469d96dbca3d8522231672e14cca77de4d5e'
  homepage 'http://fribidi.org/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
