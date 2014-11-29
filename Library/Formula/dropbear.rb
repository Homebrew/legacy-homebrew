require "formula"

class Dropbear < Formula
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2014.66.tar.bz2"
  mirror "https://dropbear.nl/mirror/releases/dropbear-2014.66.tar.bz2"
  sha1 "793f5f1bb465b3c55e795d607932e8b21c130e95"

  bottle do
    cellar :any
    sha1 "dae9dacc360506b417401b5ac33beda6648c38b3" => :mavericks
    sha1 "5f932b296fb9764d5d982e63f1196ab220c2aa3f" => :mountain_lion
    sha1 "6cb51ab0dadbe813aacd66251c84507a9c5006d1" => :lion
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure","--prefix=#{prefix}", "--enable-pam", "--enable-zlib",
                         "--enable-bundled-libtom", "--sysconfdir=#{etc}/dropbear"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
      system "dbclient", "-h"
      system "dropbearkey", "-t", "ecdsa", "-f", "testec521", "-s", "521"
      assert File.exist?("testec521")
  end
end
