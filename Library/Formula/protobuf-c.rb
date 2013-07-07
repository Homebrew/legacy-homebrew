require 'formula'

class ProtobufC < Formula
  homepage 'http://code.google.com/p/protobuf-c/'
  url 'http://protobuf-c.googlecode.com/files/protobuf-c-0.15.tar.gz'
  sha1 '4fbd93f492c52154713de1951c0a2133ddd43abb'

  depends_on 'protobuf'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
