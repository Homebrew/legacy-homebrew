require "formula"

class Libgcrypt < Formula
  homepage "http://gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.1.tar.bz2"
  sha1 "f03d9b63ac3b17a6972fc11150d136925b702f02"

  bottle do
    cellar :any
    revision 1
    sha1 "097b7d905939f048c57e5b578fdbedfd9b2d5cbb" => :mavericks
    sha1 "fe4f770a092426bd9f92aa3d5fb3254cbdd5216f" => :mountain_lion
    sha1 "3fac80790da33ba3f43e2e57ca30bbd8d88fc3e9" => :lion
  end

  depends_on "libgpg-error"

  option :universal

  resource "config.h.ed" do
    url "http://trac.macports.org/export/113198/trunk/dports/devel/libgcrypt/files/config.h.ed"
    version "113198"
    sha1 "136f636673b5c9d040f8a55f59b430b0f1c97d7a"
  end if build.universal?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    if build.universal?
      buildpath.install resource("config.h.ed")
      system "ed -s - config.h <config.h.ed"
    end

    # Parallel builds work, but only when run as separate steps
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
