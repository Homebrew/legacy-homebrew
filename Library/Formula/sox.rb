require 'formula'

class Sox <Formula
  url 'http://sourceforge.net/projects/sox/files/sox/14.3.0/sox-14.3.0.tar.gz/download'
  version '14.3.0'
  homepage 'http://sox.sourceforge.net/'
  md5 '8e3509804e6227273ef84092e1a2fea7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-gomp"
    system "make install"
  end
end
