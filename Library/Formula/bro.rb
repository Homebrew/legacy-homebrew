require "formula"

class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  head "https://github.com/bro/bro.git"

  stable do
    url "https://www.bro.org/downloads/release/bro-2.3.2.tar.gz"
    sha256 "2fe5fbda0a86b5a594116d567fd9a4c2458d30f1c6670ba8e1fac0bc8848c69b"

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
