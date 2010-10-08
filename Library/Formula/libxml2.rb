require 'formula'

class Libxml2 <Formula
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.7.7.tar.gz'
  homepage 'http://xmlsoft.org'
  md5 '9abc9959823ca9ff904f1fbcf21df066'

  keg_only :provided_by_osx

  def install
<<<<<<< HEAD
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--with-threads"
=======
    fails_with_llvm "Undefined symbols when linking", :build => "2326"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
>>>>>>> 09a02645fcf1aa3313f631174016e36917539a6e
    system "make"
    ENV.j1
    system "make install"
  end
end
