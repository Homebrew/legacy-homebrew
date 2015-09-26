class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "http://savannah.nongnu.org/projects/avrdude/"
  url "http://download.savannah.gnu.org/releases/avrdude/avrdude-6.1.tar.gz"
  mirror "http://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.1.tar.gz"
  sha256 "9e98baca8e57cad402aaa1c7b61c8de750ed4f6fed577f7e4935db0430783d3b"

  bottle do
    sha1 "2d759fea880b097754defe8016e026390dbcfb31" => :mavericks
    sha1 "83017c7fb34b0a2da5919b6b1dde9c05bf237f2a" => :mountain_lion
    sha1 "438562a4b84b4e868cdf01b81e7543053a89a7ff" => :lion
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
end
