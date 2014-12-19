require "formula"

class Tinc < Formula
  homepage "http://www.tinc-vpn.org"
  url "http://tinc-vpn.org/packages/tinc-1.0.24.tar.gz"
  sha1 "e32f56b234922570a9a8a267b1143e2752133696"
  revision 1

  bottle do
    sha1 "b41c2f938dc74d722fc671dba917162c593903ce" => :mavericks
    sha1 "c6817e85d4a8c81a070f4cd30f0cd1d116b514bf" => :mountain_lion
    sha1 "847939fa901a60bd465f94d4d850a1f1d3abf2d9" => :lion
  end

  devel do
    url "http://www.tinc-vpn.org/packages/tinc-1.1pre10.tar.gz"
    sha1 "085dcb66858dfb2ddaa6c0082c2b22b18bc65a97"
  end

  depends_on "lzo"
  depends_on "openssl"

  def install
    # Tinc does not automatically link against libresolv on Mac OS X.
    # A fix has been already merged upstream. When updating this formula
    # make sure the following changes have been applied:
    # https://github.com/gsliepen/tinc/commit/241670ec23d05800e0a04957d6293de9a39075fb
    # and remove this comment in addition to the next line.
    ENV.append "LDFLAGS", "-lresolv"

    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end
end
