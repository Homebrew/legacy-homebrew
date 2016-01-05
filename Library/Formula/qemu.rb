class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "http://wiki.qemu.org"
  url "http://wiki.qemu-project.org/download/qemu-2.5.0.tar.bz2"
  mirror "http://ftp.osuosl.org/pub/blfs/conglomeration/qemu/qemu-2.5.0.tar.bz2"
  sha256 "3443887401619fe33bfa5d900a4f2d6a79425ae2b7e43d5b8c36eb7a683772d4"
  head "git://git.qemu-project.org/qemu.git"

  bottle do
    sha256 "ceb139d710721384498e2c42110d571ea6e6b3c2eba441d241f941e35be10360" => :el_capitan
    sha256 "ebb0af6b993366595d9e120fe1c57e60a0cdc2d8339534add2a39f3385c12f71" => :yosemite
    sha256 "3faf2117178a2adc23053302fc07e16db9c1e4f42e73a4c918d69e4f5fb45557" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "gnutls"
  depends_on "glib"
  depends_on "pixman"
  depends_on "vde" => :optional
  depends_on "sdl" => :optional
  depends_on "gtk+" => :optional
  depends_on "libssh2" => :optional

  # 3.2MB working disc-image file hosted on upstream's servers for people to use to test qemu functionality.
  resource "armtest" do
    url "http://wiki.qemu.org/download/arm-test-0.2.tar.gz"
    sha256 "4b4c2dce4c055f0a2adb93d571987a3d40c96c6cbfd9244d19b9708ce5aea454"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
    ]

    # Cocoa and SDL UIs cannot both be enabled at once.
    if build.with? "sdl"
      args << "--enable-sdl" << "--disable-cocoa"
    else
      args << "--enable-cocoa" << "--disable-sdl"
    end

    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("gtk+") ? "--enable-gtk" : "--disable-gtk")
    args << (build.with?("libssh2") ? "--enable-libssh2" : "--disable-libssh2")

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    resource("armtest").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info arm_root.img")
  end
end
