require 'formula'

class LcdfTypetools < Formula
  homepage 'http://www.lcdf.org/type/'
  url 'http://www.lcdf.org/type/lcdf-typetools-2.100.tar.gz'
  sha256 '7ae7940df8a33de945c401e81aed414df796db692a30e38ba734c6117b73b2cd'

  conflicts_with 'open-mpi', :because => 'both install same set of binaries.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make install"
  end
end
