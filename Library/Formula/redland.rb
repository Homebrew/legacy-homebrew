require 'formula'

class Redland < Formula
  url 'http://download.librdf.org/source/redland-1.0.12.tar.gz'
  homepage 'http://librdf.org/'
  md5 '40f37a5ad97fdfbf984f78dcea0c6115'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'berkeley-db' => :optional

  fails_with_llvm

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=yes",
                          "--with-mysql=no",
                          "--with-bdb=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
