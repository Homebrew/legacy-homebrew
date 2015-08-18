class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4138/pcsc-lite-1.8.14.tar.bz2"
  sha256 "b91f97806042315a41f005e69529cb968621f73f2ddfbd1380111a175b02334e"

  bottle do
    sha1 "8b726aaf4467583d1fd808650229757c9561c4d5" => :yosemite
    sha1 "42eff3939a65ea2cea53b8a61dc60321c01cb00f" => :mavericks
    sha1 "3600bfdc0d7e74f27c0c0474660805f58378e903" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
