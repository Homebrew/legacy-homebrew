require 'formula'

class Redland <Formula
  url 'http://download.librdf.org/source/redland-1.0.13.tar.gz'
  homepage 'http://librdf.org/'
  md5 '96c15f36f842ad7e1c9d225e4ca97b68'

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
