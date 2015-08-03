class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4126/pcsc-lite-1.8.13.tar.bz2"
  sha256 "f315047e808d63a3262c4a040f77548af2e04d1fd707e0c2759369b926fbbc3b"

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
