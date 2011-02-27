require 'formula'

class Uudeview <Formula
  url 'http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz'
  homepage 'http://www.fpx.de/fp/Software/UUDeview/'
  md5 '0161abaec3658095044601eae82bbc5b'
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
    		"--prefix=#{prefix}", "--mandir=#{man}" , "--includedir=#{HOMEBREW_PREFIX}/include"
    system "make all"
    system "make install"
    system "cp ./uulib/*.h #{HOMEBREW_PREFIX}/include"
  end
end
