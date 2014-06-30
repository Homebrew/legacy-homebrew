require 'formula'

class Pulseaudio < Formula
  homepage "http://pulseaudio.org"
  url "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-5.0.tar.xz"
  sha1 "e420931a0b9cf37331cd06e30ba415046317ab85"

  option "with-nls", "Build with native language support"
  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "intltool" => :build if build.with? "nls"
  depends_on "gettext" => :build if build.with? "nls"

  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsamplerate"

  depends_on :x11 => :optional
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "d-bus" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  # i386 patch per MacPorts
  patch :p0 do
    url "https://trac.macports.org/export/119615/trunk/dports/audio/pulseaudio/files/i386.patch"
    sha1 "4193a6112f90d103875d2ca91462c26d811a9386"
  end

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --with-mac-sysroot=/
    ]

    args << "--with-mac-sysroot=#{MacOS.sdk_path}"
    args << "--with-mac-version-min=#{MacOS.version}"
    args << "--disable-nls" if build.without? "nls"

    if build.universal?
      args << "--enable-mac-universal"
      ENV.universal_binary
    end

    system "./configure", *args
    system "make", "install"
  end
end
