class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "http://sofia-sip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz"
  sha256 "2b01bc2e1826e00d1f7f57d29a2854b15fd5fe24695e47a14a735d195dd37c81"
  revision 1

  bottle do
    cellar :any
    sha256 "2e78cc40330c53363fb1dddc0568464001b46944628283e26811e4e6ccae28fe" => :el_capitan
    sha256 "e2f9ede8ce51b2074659a1fcf576d83031c9037aafd3c39f75330e8e7cb236a5" => :yosemite
    sha256 "1e68620530a8dda00d795bdf92f7c564174eefde5d7e703839de2e080bd89ea4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
