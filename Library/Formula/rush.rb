require 'formula'

class Rush < Formula
  homepage 'http://www.gnu.org/software/rush/'
  url 'http://ftpmirror.gnu.org/rush/rush-1.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/rush/rush-1.7.tar.gz'
  sha1 'f886eaf093332a8b8503afcf8ca2acff7eea7191'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
