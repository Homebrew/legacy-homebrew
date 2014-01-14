require 'formula'

class Lightning < Formula
  homepage 'http://www.gnu.org/software/lightning/'
  url 'http://ftpmirror.gnu.org/lightning/lightning-2.0.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/lightning/lightning-2.0.3.tar.gz'
  sha1 'b774b62b1470368bc5886234b7228d7058352484'

  def install
    system "./configure","--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
