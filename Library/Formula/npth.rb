require "formula"

class Npth < Formula
  homepage "https://gnupg.org/index.html"
  url "ftp://ftp.gnupg.org/gcrypt/npth/npth-1.1.tar.bz2"
  sha1 "597ce74402e5790553a6273130b214d7ddd0b05d"

  bottle do
    cellar :any
    sha1 "6830f2d744b23859fa690454d02a2c60a8ae73c4" => :mavericks
    sha1 "9ea753df5be9e97514f67ebe5969146064648f23" => :mountain_lion
    sha1 "931d244c23b907c732286cfa5099e03978506ce5" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
