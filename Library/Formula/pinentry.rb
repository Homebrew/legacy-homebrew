class Pinentry < Formula
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.1.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.1.tar.bz2"
  sha256 "9cd08e856b395df3adc7124170b53f77c6d5c8bf88e899e818648ec70d3e9695"

  bottle do
    cellar :any
    sha1 "430ee45b7236eecc16a089d7601b15f78c010684" => :yosemite
    sha1 "6eab9da0d163a0ca3d3717092a50048863dd16af" => :mavericks
    sha1 "ffd319f02d77015c80a40c5a4f055db03315503a" => :mountain_lion
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
