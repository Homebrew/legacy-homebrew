require 'formula'

class ProtobufC <Formula
  url 'http://protobuf-c.googlecode.com/files/protobuf-c-0.13.tar.gz'
  homepage 'http://code.google.com/p/protobuf-c/'
  sha1 '3144f260b736855cea2984731c2ba1647d40dfe0'

  depends_on 'protobuf'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
