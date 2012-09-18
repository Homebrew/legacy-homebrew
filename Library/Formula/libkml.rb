require 'formula'

class Libkml < Formula
  url 'http://libkml.googlecode.com/files/libkml-1.2.0.tar.gz'
  homepage 'http://code.google.com/p/libkml/'
  sha1 '3fa5acdc2b2185d7f0316d205002b7162f079894'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
