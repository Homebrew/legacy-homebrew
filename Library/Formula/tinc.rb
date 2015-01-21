require "formula"

class Tinc < Formula
  homepage "http://www.tinc-vpn.org"
  url "http://tinc-vpn.org/packages/tinc-1.0.25.tar.gz"
  sha1 "b728e1ed02862aab04b2a53a62c2f67edd0c3949"

  bottle do
    sha1 "b41c2f938dc74d722fc671dba917162c593903ce" => :mavericks
    sha1 "c6817e85d4a8c81a070f4cd30f0cd1d116b514bf" => :mountain_lion
    sha1 "847939fa901a60bd465f94d4d850a1f1d3abf2d9" => :lion
  end

  devel do
    url "http://www.tinc-vpn.org/packages/tinc-1.1pre11.tar.gz"
    sha1 "ee6920d87b377c39da71d7ad5807a37f55e4e3be"
  end

  depends_on "lzo"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end
end
