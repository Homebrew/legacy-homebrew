require 'formula'

class Libcue < Formula
  homepage 'http://sourceforge.net/projects/libcue/'
  url 'https://downloads.sourceforge.net/project/libcue/libcue/1.4.0/libcue-1.4.0.tar.bz2'
  sha1 '3fd31f2da7c0e3967d5f56363f3051a85a8fd50d'

  bottle do
    cellar :any
    revision 1
    sha1 "4f77185f22c3099fe9f310494dedb9ac7913be77" => :yosemite
    sha1 "16e526dbe49a96dd8c9bd688b31195d756dd7bf0" => :mavericks
    sha1 "baa3227a1734763ba21355a6e403b81a205919d2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
