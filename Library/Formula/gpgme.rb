require 'formula'

class Gpgme < Formula
  homepage 'http://www.gnupg.org/related_software/gpgme/'
  url 'ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.4.3.tar.bz2'
  sha1 'ffdb5e4ce85220501515af8ead86fd499525ef9a'

  bottle do
    sha1 "94d777bbeb25382cc1d0511c8833f715811dd314" => :mavericks
    sha1 "48b1c7504b9105b006ebc8957d4934cd808706cb" => :mountain_lion
    sha1 "16ae29744f639aa3fc837a035c36b56a788c573d" => :lion
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
