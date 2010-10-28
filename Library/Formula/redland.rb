require 'formula'

class Redland <Formula
  url 'http://download.librdf.org/source/redland-1.0.12.tar.gz'
  homepage 'http://librdf.org/'
  md5 '40f37a5ad97fdfbf984f78dcea0c6115'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'berkeley-db' => :optional

  def install
    fails_with_llvm
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-sqlite=yes",
                          "--with-bdb=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
