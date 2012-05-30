require 'formula'

class Php53Pinba < Formula
  homepage 'http://pinba.org/'
  url 'http://pinba.org/files/snapshots/pinba_extension-latest.tar.gz'
  md5 '724987e50e0a637801574b321dad74ef'

  depends_on 'protobuf'

  def install
    system "phpize"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make install"
  end
end
