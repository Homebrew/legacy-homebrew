require 'formula'

class Lightning < Formula
  homepage 'http://www.gnu.org/software/lightning/'
  url 'http://ftpmirror.gnu.org/lightning/lightning-2.0.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/lightning/lightning-2.0.2.tar.gz'
  sha1 'b47a6d0ce071ca374d16399afab6837c4dbe9547'

  def install
    system "./configure","--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
