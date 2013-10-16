require 'formula'

class Libtextcat < Formula
  homepage 'http://software.wise-guys.nl/libtextcat/'
  url 'http://software.wise-guys.nl/download/libtextcat-2.2.tar.gz'
  sha1 'e98d7149d6a20fdbb58cc0b79cb5e3f95ae304e4'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (prefix/'include').install "src/common.h"
    (prefix/'include').install "src/constants.h"
    (prefix/'include').install "src/fingerprint.h"
    (prefix/'include').install "src/textcat.h"
    (prefix/'include').install "src/wg_mempool.h"
    (prefix/'share').install "langclass/LM"
    (prefix/'share').install "langclass/ShortTexts"
    (prefix/'share').install "langclass/conf.txt"
  end

  test do
    system "#{bin}/createfp < #{prefix}/README"
  end
end
