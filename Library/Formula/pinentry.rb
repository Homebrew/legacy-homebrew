require "formula"

class Pinentry < Formula
  homepage "http://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.0.tar.bz2"
  sha1 "f8e5c774c35fbb91d84e82559baf76f6b4513236"

  bottle do
    cellar :any
    sha1 "c31bea35dfee2a0781fbb953a4bf17e215f08df8" => :yosemite
    sha1 "007ad6402a6ec5b38bc852849d0fcdcf957ea6dc" => :mavericks
    sha1 "44787bbcfb7e53371fe58eeb4076ff5529d7c24c" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt4",
                          "--disable-pinentry-gtk2"
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
