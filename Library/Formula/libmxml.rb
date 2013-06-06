require 'formula'

class Libmxml < Formula
  homepage 'http://www.minixml.org/'
  url 'http://www.msweet.org/files/project3/mxml-2.7.tar.gz'
  sha1 'a3bdcab48307794c297e790435bcce7becb9edae'

  depends_on :xcode # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}"

    # Makefile hard-codes the path to /Developer
    inreplace "Makefile", "/Developer/usr/bin/docsetutil", MacOS.locate('docsetutil')

    system "make"
    system "make install"
  end
end
