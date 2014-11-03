require 'formula'

class Gpgme < Formula
  homepage 'http://www.gnupg.org/related_software/gpgme/'
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.4.3.tar.bz2'
  sha1 'ffdb5e4ce85220501515af8ead86fd499525ef9a'

  bottle do
    revision 1
    sha1 "60d557c728754011a62f4ede0e04ca786bf5b161" => :yosemite
    sha1 "ae98c80946c947f967d44436717ed492b0f08420" => :mavericks
    sha1 "9e3d8a25586683f0aeb050b341b38da79ba770d5" => :mountain_lion
  end

  depends_on 'gnupg'
  depends_on 'libgpg-error'
  depends_on 'libassuan'
  depends_on 'pth'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static",
                          "--without-gpgsm",
                          "--without-gpgconf"
    system "make"
    system "make check"
    system "make install"
  end
end
