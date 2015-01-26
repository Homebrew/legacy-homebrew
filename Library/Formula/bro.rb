require "formula"

class Bro < Formula
  homepage "https://www.bro.org"
  head "https://github.com/bro/bro.git"

  stable do
    url "https://www.bro.org/downloads/release/bro-2.3.2.tar.gz"
    sha256 "2fe5fbda0a86b5a594116d567fd9a4c2458d30f1c6670ba8e1fac0bc8848c69b"

  end

  bottle do
    sha1 "19d44e396ea474a01625333cc005d59c15a1a779" => :yosemite
    sha1 "3ec9e7b7c05b68668f6559322372a2f57344f735" => :mavericks
    sha1 "6e69354144ece0c4b99fe0c8f07c353e5892bf3c" => :mountain_lion
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
