require 'formula'

class Orc <Formula
  homepage 'http://code.entropywave.com/projects/orc/'
  url 'http://code.entropywave.com/download/orc/orc-0.4.11.tar.gz'
  md5 'b8b0b148d319422c3ad250c29483b3c4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
