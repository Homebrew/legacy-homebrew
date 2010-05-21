require 'formula'

class Tnef <Formula
  url 'http://downloads.sourceforge.net/project/tnef/tnef/v1.4.7/tnef-1.4.7.tar.gz'
  md5 '00978a8ad8cc79a1ee605172f882ebe9'
  homepage 'http://sourceforge.net/projects/tnef/'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
