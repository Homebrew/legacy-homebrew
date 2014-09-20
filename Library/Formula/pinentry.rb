require 'formula'

class Pinentry < Formula
  homepage 'http://www.gnupg.org/related_software/pinentry/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.8.4.tar.bz2'
  sha1 '36c94980ceab5c15e188de121f7ab4c7ee6b3521'

  bottle do
    cellar :any
    sha1 "df293406a5b8b1135eb9a3f320d8556d9ca402a9" => :mavericks
    sha1 "b675055db365dd414994c8fb3831c1172372d914" => :mountain_lion
    sha1 "50ee5e73c50b280e1665aa4b358a265a2e77aa3b" => :lion
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
