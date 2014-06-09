require 'formula'

class Gforth < Formula
  homepage 'http://bernd-paysan.de/gforth.html'
  url 'http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.2.tar.gz'
  sha256 '77db9071c2442da3215da361b71190bccb153f81f4d01e5e8bc2c2cf8ee81b48'

  depends_on 'libtool' => :run
  depends_on 'libffi'
  depends_on 'pcre'

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/config/config.*"], buildpath
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make" # Separate build steps.
    system "make install"
  end
end
