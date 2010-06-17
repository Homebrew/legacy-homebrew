require 'formula'

class Redland <Formula
  url 'http://download.librdf.org/source/redland-1.0.10.tar.gz'
  homepage 'http://librdf.org/'
  md5 'bdbb9b8dc614fc09a14cd646079619e1'

  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'pkg-config'
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
