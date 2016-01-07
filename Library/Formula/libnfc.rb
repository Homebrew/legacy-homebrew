class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "http://www.libnfc.org/"
  url "https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2"
  sha256 "945e74d8e27683f9b8a6f6e529557b305d120df347a960a6a7ead6cb388f4072"

  bottle do
    sha256 "792064362ef2b224a15190b6fcf97066c7a1d47a3bee13495134aafb067cc11d" => :el_capitan
    sha256 "3f2e7a57fca1f12b4b938c6136036f889562540e6c6a8e5188cd32fabd927a9c" => :yosemite
    sha256 "cabb3f773d92c2cd95af437d6f4c567529229b26b82d568af1c89ec50b674f59" => :mavericks
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
