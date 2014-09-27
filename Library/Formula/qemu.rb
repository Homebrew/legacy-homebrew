require "formula"

class Qemu < Formula
  homepage "http://www.qemu.org/"
  head "git://git.qemu-project.org/qemu.git"
  url "http://wiki.qemu-project.org/download/qemu-2.1.2.tar.bz2"
  sha1 "f5f9eefa8fece7dead0487a2cca25f90e3dab3d9"

  bottle do
    sha1 "52345b6ec0fb3a9a4da93b3adc861e247a9d8702" => :mavericks
    sha1 "2027be04ff3885fe38570e05726949b9b6029abc" => :mountain_lion
    sha1 "d6603f9b5aa3e72c02f9495d287cc4cbd5a5bf22" => :lion
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

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --disable-bsd-user
      --disable-guest-agent
    ]
    args << (build.with?("sdl") ? "--enable-sdl" : "--disable-sdl")
    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("gtk+") ? "--enable-gtk" : "--disable-gtk")
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", *args
    system "make", "V=1", "install"
  end
end
