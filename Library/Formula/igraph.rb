require 'formula'

class Igraph < Formula
  homepage 'http://igraph.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/igraph/igraph-0.6.5.tar.gz'
  sha1 'f1605c5592e8bf3c97473f7781e77b6608448f78'

  option :universal

  # GMP is optional, and doesn't have a universal build
  depends_on 'gmp' => :optional unless build.universal?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
