require 'formula'

class Libcue <Formula
  url 'http://downloads.sourceforge.net/project/libcue/libcue/1.3.0/libcue-1.3.0.tar.bz2'
  homepage 'http://sourceforge.net/projects/libcue/'
  md5 'afd94427ff1e59f093a1b8b29aea2ecf'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
