class Libnxml < Formula
  desc "C library for parsing, writing, and creating XML files"
  homepage "http://www.autistici.org/bakunin/libnxml/"
  url "http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz"
  sha256 "0f9460e3ba16b347001caf6843f0050f5482e36ebcb307f709259fd6575aa547"

  bottle do
    cellar :any
    revision 1
    sha1 "7cb66793cd407da933402efdba8fef4c0a6df5e9" => :yosemite
    sha1 "ebc5579cac15cc564df904594fb1e773bb90e747" => :mavericks
    sha1 "656ec4f843adb2ab16fc30ea708fb5abccd76490" => :mountain_lion
  end

  depends_on "curl" if MacOS.version < :lion # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
