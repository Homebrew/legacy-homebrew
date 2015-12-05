class P11Kit < Formula
  desc "Library to load and enumerate PKCS# 11 modules"
  homepage "http://p11-glue.freedesktop.org"
  url "http://p11-glue.freedesktop.org/releases/p11-kit-0.18.4.tar.gz"
  sha256 "df5424ec39e17c2b3b98819bf772626e9b8c73871a8b82e54151f6297d8575fd"

  bottle do
    sha256 "1646b716f34a5fa2bbd4907c40d99234548c172ed89b4fb8aa5c56c4d0ea4ce3" => :yosemite
    sha256 "cb3882a70ed35750592d28710d477f73b65934f1ebd78b14e9d9a1d7fa1a3c33" => :mavericks
    sha256 "c00a60ea382bc99e8d40039fc4a6f8ca01664295fc13459c255618d58f612909" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtasn1"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-trust-module"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
