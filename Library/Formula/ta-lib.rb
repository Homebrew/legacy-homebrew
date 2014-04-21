require 'formula'

class TaLib < Formula
  homepage 'http://ta-lib.org/index.html'
  url 'https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz'
  sha1 'b326b91e79ca1e569e95aad91e87a38640dd5f1b'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    bin.install 'src/tools/ta_regtest/.libs/ta_regtest'
  end

  test do
    system "#{bin}/ta_regtest"
  end
end
