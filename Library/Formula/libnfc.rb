class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "http://www.libnfc.org/"
  url "https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2"
  sha256 "945e74d8e27683f9b8a6f6e529557b305d120df347a960a6a7ead6cb388f4072"

  bottle do
    sha256 "76437c13d93466c6f64ebcdee2a8aea6fa54bf129755f368844713a7817b263e" => :el_capitan
    sha256 "80d5a6bb48a2bfe3079689d7b1655c128dbaab946a05528344e284a1bea5173f" => :yosemite
    sha256 "5f63291718ab86e92d0afbaae02fba9b1a2a4d355524d098bc894ffb409b4b6f" => :mavericks
    sha256 "72fde407ef486e39b73f37c92a4d585e47c2e9dad1528c1a40e3ffe0338af6b8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-serial-autoprobe",
                          "--with-drivers=all"
    system "make", "install"
    (prefix/"etc/nfc/libnfc.conf").write "allow_intrusive_scan=yes"
  end

  test do
    system "#{bin}/nfc-list"
  end
end
