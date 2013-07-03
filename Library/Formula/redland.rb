require 'formula'

class Redland < Formula
  homepage 'http://librdf.org/'
  url 'http://download.librdf.org/source/redland-1.0.16.tar.gz'
  sha1 '0dc3d65bee6d580cae84ed261720b5b4e6b1f856'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'berkeley-db' => :optional
  depends_on 'sqlite' => :recommended

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=yes",
                          "--with-mysql=no",
                          "--with-bdb=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
