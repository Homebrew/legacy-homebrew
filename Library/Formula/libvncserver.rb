require "formula"

class Libvncserver < Formula
  homepage "https://libvnc.github.io/"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.10.tar.gz"
  sha256 "ed10819a5bfbf269969f97f075939cc38273cc1b6d28bccfb0999fba489411f7"

  head "https://github.com/LibVNC/libvncserver.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gnutls" => :recommended
  depends_on "gtk+" => :optional
  depends_on "libgcrypt" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "openssl" => :recommended
  depends_on "zlib" => :recommended

  def install
    system "autoreconf", "--install", "--force"

    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--without-libva"]
    args << "--#{( build.with? 'openssl' ) ? 'with' : 'without'}-ssl"
    args << "--#{( build.with? 'libgcrypt' ) ? 'with' : 'without'}-gcrypt"
    args << "--#{( build.with? 'gnutls' ) ? 'with' : 'without'}-gnutls"
    args << "--#{( build.with? 'zlib' ) ? 'with' : 'without'}-zlib"
    args << "--#{( build.with? 'jpeg' ) ? 'with' : 'without'}-jpeg"
    args << "--#{( build.with? 'png' ) ? 'with' : 'without'}-png"

    system "./configure", *args
    system "make", "install"
  end
end
