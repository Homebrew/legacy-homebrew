require 'formula'

class Zsync < Formula
  homepage 'http://zsync.moria.org.uk/'
  url 'http://zsync.moria.org.uk/download/zsync-0.6.2.tar.bz2'
  sha1 '5e69f084c8adaad6a677b68f7388ae0f9507617a'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
