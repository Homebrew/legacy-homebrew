require "formula"

class Qemu < Formula
  homepage "http://www.qemu.org/"
  head "git://git.qemu-project.org/qemu.git"
  url "http://wiki.qemu-project.org/download/qemu-2.2.0.tar.bz2"
  sha1 "9a16623775a92fd25334f4eced4e6a56ab536233"

  bottle do
    sha1 "6ddb5245e0669258d8514143166f520749080fec" => :mavericks
    sha1 "db0a11aded67b12bdfd9923b91de3d2fd2115423" => :mountain_lion
    sha1 "5ca2a1a9937190238ddc7ec416bd7d70f7d62a3f" => :lion
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
