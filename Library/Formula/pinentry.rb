require 'formula'

class Pinentry < Formula
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.2.tar.bz2'
  sha1 'eeee9e80ea02f63bdac1cb03eb1785ab2cd57f90'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt",
                          "--disable-pinentry-qt4",
                          "--disable-pinentry-gtk",
                          "--disable-pinentry-gtk2"
    system "make install"
  end
end
