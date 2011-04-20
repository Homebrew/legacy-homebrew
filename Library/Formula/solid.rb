require 'formula'

class Solid < Formula
  url 'http://www.dtecta.com/files/solid-3.5.6.tgz'
  homepage 'http://www.dtecta.com/'
  md5 '8852e8fe34083082097f7f7330cfeccc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--infodir=#{info}", "--prefix=#{prefix}"
    
    # exclude the examples from compiling!
    # the examples do not compile because the include statements
    # for the GLUT library are not platform independent
##    inreplace "Makefile", "SUBDIRS = src include examples doc", "SUBDIRS = src include doc" #/^SUBDIRS = src include examples doc$/,
##              "SUBDIRS = src include doc"
    inreplace "Makefile", " examples ", " "


    system "make"
    system "make install"
  end
end