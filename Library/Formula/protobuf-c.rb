require 'formula'

class ProtobufC < Formula
  url 'http://protobuf-c.googlecode.com/files/protobuf-c-0.15.tar.gz'
  homepage 'http://code.google.com/p/protobuf-c/'
  sha1 '4fbd93f492c52154713de1951c0a2133ddd43abb'

  depends_on 'protobuf'

  def install
    ENV.j1 # Fixed in a post-0.14 change
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
