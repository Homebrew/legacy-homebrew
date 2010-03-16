require 'formula'

class ProtobufC <Formula
  url 'http://protobuf-c.googlecode.com/files/protobuf-c-0.12.tar.gz'
  homepage 'http://code.google.com/p/protobuf-c/'
  md5 'fefe81642f1e5565eb8a661e597b5bf7'

  depends_on 'protobuf'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
