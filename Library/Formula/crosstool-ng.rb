require 'formula'
class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org/'
  head "http://crosstool-ng.org/hg/crosstool-ng", :using => :hg
  version "head" 

  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'
  def install
    system "./configure", "--with-sed=gsed",
                          "--with-libtool=glibtool",
                          "--with-libtoolize=glibtoolize",
                          "--with-objcopy=gobjcopy",
                          "--with-objdump=gobjdump",
                          "--with-readelf=greadelf",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "ct-ng updatetools"
  end
end