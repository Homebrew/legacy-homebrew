require 'formula'

class Libewf < Formula
  homepage 'http://sourceforge.net/projects/libewf/'
  url 'http://downloads.sourceforge.net/project/libewf/libewf2/libewf-20120813/libewf-20120813.tar.gz'
  sha1 'a8226c42dd55022569b8234fba997f8bd40b9303'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
