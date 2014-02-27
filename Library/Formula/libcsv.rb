require 'formula'

class Libcsv < Formula
  homepage 'http://sourceforge.net/projects/libcsv/'
  url 'https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz'
  sha1 '2f637343c3dfac80559595f519e8f78f25acc7c1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end
