class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "http://download.savannah.gnu.org/releases/avrdude/avrdude-6.2.tar.gz"
  mirror "http://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.2.tar.gz"
  sha256 "e65f833493b7d63a4436c7056694a0f04ae5b437b72cc084e32c58bc543b0f91"

  bottle do
    sha256 "11694fb816ab1dc789ee40bf9e5985c19d0d889b2c6ea7514a1e0b7908d5450b" => :mavericks
    sha256 "e50e3589b2d1656b1e8773bb2853cfa71268b0826b88d81421bdc89877ec7976" => :mountain_lion
    sha256 "53b39b6a0972dd9046b74790661c4bcc325053066493b57d0a25f5fcd3d7c9d4" => :lion
  end

  head do
    url "svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :macos => :snow_leopard # needs GCD/libdispatch
  depends_on "libusb-compat"
  depends_on "libftdi0"
  depends_on "libelf"
  depends_on "libhid" => :optional

  def install
    if build.head?
      inreplace "bootstrap", /libtoolize/, "glibtoolize"
      system "./bootstrap"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
