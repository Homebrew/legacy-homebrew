require 'formula'

class Orc <Formula
  homepage 'http://code.entropywave.com/projects/orc/'
  url 'http://code.entropywave.com/download/orc/orc-0.4.5.tar.gz'
  md5 'e26e59428b13ec251916f34bea96eee5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-gtk-doc"
    system "make install"
  end
end
