class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.2.1/isync-1.2.1.tar.gz"
  sha256 "e716de28c9a08e624a035caae3902fcf3b511553be5d61517a133e03aa3532ae"

  bottle do
    cellar :any
    sha256 "b236f25f8fb6f2285fb6775deba1e61b89df904fc2fc933f2546bb69d0bb9ec6" => :el_capitan
    sha256 "a4406974110a2f4ea3aaa81f0232c00f8aa9b572fab8709f1e16c7dc2d6ab6f6" => :yosemite
    sha256 "3be99741095c146ef4bf44732cf3850aa62bf23a8676d6289bb11b988ac328fd" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/isync/isync"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"get-cert", "duckduckgo.com:443"
  end
end
