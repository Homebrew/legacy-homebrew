require 'formula'

class TaLib < Formula
  homepage 'http://ta-lib.org/index.html'
  url 'https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz'
  sha1 'b326b91e79ca1e569e95aad91e87a38640dd5f1b'

  bottle do
    cellar :any
    sha1 "3b41107bf0e91d2a7e12f06dddd94e2e8ffb52c3" => :mavericks
    sha1 "2ab9b06907158d2e57aa281f9efb75954d778fce" => :mountain_lion
    sha1 "a6c6e471d583eb467c59e0252b44ce9e552b03fc" => :lion
  end

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
