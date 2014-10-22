require 'formula'

class Pinentry < Formula
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.4.tar.bz2'
  sha1 '36c94980ceab5c15e188de121f7ab4c7ee6b3521'

  bottle do
    cellar :any
    revision 1
    sha1 "c31bea35dfee2a0781fbb953a4bf17e215f08df8" => :yosemite
    sha1 "007ad6402a6ec5b38bc852849d0fcdcf957ea6dc" => :mavericks
    sha1 "44787bbcfb7e53371fe58eeb4076ff5529d7c24c" => :mountain_lion
  end

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
