require 'formula'

class Tnef < Formula
  homepage 'http://sourceforge.net/projects/tnef/'
  url 'http://downloads.sourceforge.net/project/tnef/tnef/tnef-1.4.8.tar.gz'
  sha1 '19431176ee523fe3fd5e745882a9083426cc5671'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
