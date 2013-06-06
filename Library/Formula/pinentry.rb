require 'formula'

class Pinentry < Formula
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.3.tar.bz2'
  sha1 'fc0efe5d375568f90ddbb23ee68e173411a49d4a'

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
