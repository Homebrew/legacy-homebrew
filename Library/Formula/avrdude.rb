class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "http://download.savannah.gnu.org/releases/avrdude/avrdude-6.2.tar.gz"
  mirror "http://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.2.tar.gz"
  sha256 "e65f833493b7d63a4436c7056694a0f04ae5b437b72cc084e32c58bc543b0f91"

  bottle do
    sha256 "b2ac65f070879456e2047ba543a7fafb1d45c98b745b7915b4059ea90c10dfcd" => :el_capitan
    sha256 "4c092d851e6ed8ed58ac5a1997606db420ee153289d4289917fad50f8432d5ad" => :yosemite
    sha256 "a3b312dde0f3a268d6ccc9085e4a14d8d7703ff1ae09a9257b373976e7cf49ec" => :mavericks
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
