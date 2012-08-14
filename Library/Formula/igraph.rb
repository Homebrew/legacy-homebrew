require 'formula'

class Igraph < Formula
  homepage 'http://igraph.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/igraph/igraph-0.6.tar.gz'
  sha1 'd9a6e7c0462b5948ebfbf9f1d2685141f5867fe3'

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
