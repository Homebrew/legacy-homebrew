require 'formula'

class Libkml <Formula
  url 'http://libkml.googlecode.com/files/libkml-1.2.0.tar.gz'
  homepage 'http://code.google.com/p/libkml/'
  md5 '25d534437f971bf55a945608e39fea79'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
