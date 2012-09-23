require 'formula'

class Libcsv < Formula
  homepage 'http://sourceforge.net/projects/libcsv/'
  url 'http://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.2/libcsv-3.0.2.tar.gz'
  sha1 '253f23ecedcfdc5b3e4884458d77d6806c07a48d'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end
