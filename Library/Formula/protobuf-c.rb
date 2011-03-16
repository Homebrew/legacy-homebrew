require 'formula'

class ProtobufC < Formula
  url 'http://protobuf-c.googlecode.com/files/protobuf-c-0.14.tar.gz'
  homepage 'http://code.google.com/p/protobuf-c/'
  sha1 'b3af990906d8a8d86e2fb8cb6f39d0a37616ff8a'

  depends_on 'protobuf'

  def install
    ENV.j1 # Fixed in a post-0.14 change
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
