require 'formula'

class Igraph < Formula
  homepage 'http://igraph.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/igraph/C%20library/0.6.5/igraph-0.6.5.tar.gz'
  sha1 'f1605c5592e8bf3c97473f7781e77b6608448f78'

  depends_on 'gmp' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
