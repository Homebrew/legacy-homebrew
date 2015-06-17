require "formula"

class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  head "https://github.com/bro/bro.git"

  stable do
    url "https://www.bro.org/downloads/release/bro-2.4.tar.gz"
    sha256 "740c0d0b0bec279c2acef5e1b6b4d0016c57cd02a729f5e2924ae4a922e208b2"

  end

  bottle do
    sha1 "2aa244b83b9aeac9a63624defabc59b9c9f3ce48" => :yosemite
    sha1 "00140842870f97f164de968471e366882774d84e" => :mavericks
    sha1 "2710acd445167b1fece844f15367db3ce55036bb" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip" => :recommended
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
