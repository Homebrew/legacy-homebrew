class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://sourceforge.net/projects/openocd/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.9.0/openocd-0.9.0.tar.bz2"
  sha256 "837042ac9a156b9363cbffa1fcdaf463bfb83a49331addf52e63119642b5f443"

  bottle do
    revision 1
    sha256 "7b486a00de7c5587902482eddbca668b28cf2a0f4834990eb72f347aa82de3f9" => :el_capitan
    sha256 "5f100f62924464a31d2a5d3ad83c8305a5b9c0e0bf7c2afe05f06340f075f318" => :yosemite
    sha256 "64c7f397c5e0b7af7d91089a386a3a0c0c600987db7a25f55658bfe394af9d7b" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/openocd/code"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  option "without-hidapi", "Disable building support for devices using HIDAPI (CMSIS-DAP)"
  option "without-libftdi", "Disable building support for libftdi-based drivers (USB-Blaster, ASIX Presto, OpenJTAG)"
  option "without-libusb",  "Disable building support for all other USB adapters"

  depends_on "pkg-config" => :build
  depends_on "libusb" => :recommended
  # some drivers are still not converted to libusb-1.0
  depends_on "libusb-compat" if build.with? "libusb"
  depends_on "libftdi" => :recommended
  depends_on "hidapi" => :recommended

  def install
    # all the libusb and hidapi-based drivers are auto-enabled when
    # the corresponding libraries are present in the system
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-dummy
      --enable-buspirate
      --enable-jtag_vpi
      --enable-remote-bitbang
    ]

    if build.with? "libftdi"
      args << "--enable-usb_blaster_libftdi"
      args << "--enable-presto_libftdi"
      args << "--enable-openjtag_ftdi"
      args << "--enable-legacy-ft2232_libftdi"
    end

    ENV["CCACHE"] = "none"

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
