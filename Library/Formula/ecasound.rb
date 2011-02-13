require 'formula'

class Ecasound <Formula
  url 'http://ecasound.seul.org/download/ecasound-2.7.2.tar.gz'
  homepage 'http://www.eca.cx/ecasound/'
  md5 '40498ceed9cc7622ee969c427f13921c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
