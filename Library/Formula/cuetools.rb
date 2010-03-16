require 'formula'

class Cuetools <Formula
  url 'http://download.berlios.de/cuetools/cuetools-1.3.1.tar.gz'
  homepage 'http://developer.berlios.de/projects/cuetools/'
  md5 '45575f7a1bdc6615599fa6cb49845cca'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}"
    system "make install"
  end
end
