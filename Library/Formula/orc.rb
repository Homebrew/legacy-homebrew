require 'brewkit'

class Orc <Formula
  head 'git://code.entropywave.com/git/orc.git'
  homepage 'http://code.entropywave.com/projects/orc/'

  def install
    system "./autogen.sh", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-gtk-doc"
    system "make install"
  end
end
