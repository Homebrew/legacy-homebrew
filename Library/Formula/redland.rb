require 'formula'

class Redland < Formula
  homepage 'http://librdf.org/'
  url 'http://download.librdf.org/source/redland-1.0.15.tar.gz'
  sha1 'e93d6fafaeebdf9f15a1044be6f4a88270f007af'

  depends_on 'pkg-config' => :build
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'berkeley-db' => :optional

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-sqlite=yes",
                          "--enable-modular=no", # see http://bugs.librdf.org/mantis/view.php?id=460
                          "--with-mysql=no",
                          "--with-bdb=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
