require 'formula'

class Sdcv < Formula
  homepage 'http://sdcv.sourceforge.net/'
  url 'https://sdcv.svn.sourceforge.net/svnroot/sdcv/trunk', :revision => '38'
  version '0.4.3'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'readline'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      In C++, clang supports variable length arrays in very limited 
      circumstances, the element type of a variable length array must 
      be a POD ("plain old data") type.
      More detail here: http://clang.llvm.org/compatibility.html
      EOS
  end

  def patches
    { :p0 => "https://trac.macports.org/export/100327/trunk/dports/textproc/sdcv/files/patch-setlocale.diff" }
  end

  def install
    system "autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
