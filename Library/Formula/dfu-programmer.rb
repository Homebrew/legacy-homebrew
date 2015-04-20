class DfuProgrammer < Formula
  homepage "http://dfu-programmer.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dfu-programmer/dfu-programmer/0.7.2/dfu-programmer-0.7.2.tar.gz"
  sha256 "1db4d36b1aedab2adc976e8faa5495df3cf82dc4bf883633dc6ba71f7c4af995"

  head do
    url "https://github.com/dfu-programmer/dfu-programmer.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "libusb-compat"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-libusb_1_0"
    system "make", "install"
  end

  test do
    system bin/"dfu-programmer", "--targets"
  end
end
