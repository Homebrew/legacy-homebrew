class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "http://sourceforge.net/projects/openocd/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.9.0/openocd-0.9.0.tar.bz2"
  sha256 "837042ac9a156b9363cbffa1fcdaf463bfb83a49331addf52e63119642b5f443"

  bottle do
    sha256 "4065e33b93ee3c4f898fe160ab6e10656884c1be642a1730a4a04c281f5fad49" => :el_capitan
    sha256 "4122f7c2510f900833e0cd6009fc42d8e019684eeca3588befd00888acd8c610" => :yosemite
    sha256 "bf238101c44d7ee455c886fc5c2e370bb7a9741c18d73e71ab689fc527ee77c1" => :mavericks
    sha256 "637a2fa7abc4ddf6e8717081aab86020997b0a44d60901f6e3d408c07a9599d4" => :mountain_lion
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
