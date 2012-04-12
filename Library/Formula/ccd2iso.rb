require 'formula'

class Ccd2iso < Formula
  url 'http://downloads.sourceforge.net/project/ccd2iso/ccd2iso/ccd2iso-0.3/ccd2iso-0.3.tar.gz'
  homepage 'http://ccd2iso.sourceforge.net/'
  sha1 'cbefdc086adf45138d921a4a7c0ff012dd7c9ca7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
