require 'formula'

class Redland < Formula
  url 'http://download.librdf.org/source/redland-1.0.15.tar.gz'
  homepage 'http://librdf.org/'
  md5 'b0deb87f3c7d3237a3d587c1e0f2f266'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'berkeley-db' => :optional

  fails_with_llvm :build => 2334

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=yes",
                          "--with-mysql=no",
                          "--with-bdb=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
