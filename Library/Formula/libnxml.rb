require 'formula'

class Libnxml < Formula
  homepage 'http://www.autistici.org/bakunin/libnxml/'
  url 'http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz'
  sha1 '2bcb17ea01aa953d0f8cbc116e025bb837bec4aa'

  bottle do
    cellar :any
    revision 1
    sha1 "7cb66793cd407da933402efdba8fef4c0a6df5e9" => :yosemite
    sha1 "ebc5579cac15cc564df904594fb1e773bb90e747" => :mavericks
    sha1 "656ec4f843adb2ab16fc30ea708fb5abccd76490" => :mountain_lion
  end

  depends_on 'curl' if MacOS.version < :lion # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
