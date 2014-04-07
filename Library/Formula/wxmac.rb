require 'formula'

class Wxmac < Formula
  homepage "http://www.wxwidgets.org"
  url "https://downloads.sourceforge.net/project/wxwindows/3.0.0/wxWidgets-3.0.0.tar.bz2"
  sha1 "756a9c54d1f411e262f03bacb78ccef085a9880a"

  bottle do
    sha1 "6a5b2ff59a3f7b4c78658ed4f3cda543bfc7f325" => :mavericks
    sha1 "fed5982d493eb7881a253c09d80f47a34fe06bb7" => :mountain_lion
    sha1 "a1d9c9c5698d7459d2dce266647b04312dcc12e5" => :lion
  end

  # Upstream patch for starting non-bundled apps like gnuplot, see:
  # http://trac.wxwidgets.org/ticket/15613
  patch :p2 do
    url "http://trac.wxwidgets.org/changeset/75142/wxWidgets/trunk/src/osx/cocoa/utils.mm?format=diff&new=75142"
    sha1 "de67a8f8da479a5ab553d1c5444fc093975ff818"
  end

  def install
    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    # need to enable universal binary build in order to build all x86_64
    # headers need to specify x86_64 and i386 or will try to build for ppc arch
    # and fail on newer OSes
    # https://trac.macports.org/browser/trunk/dports/graphics/wxWidgets30/Portfile#L80
    ENV.universal_binary
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-shared",
      "--enable-unicode",
      "--enable-std_string",
      "--enable-display",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-libjpeg",
      "--with-libtiff",
      # Otherwise, even in superenv, the internal libtiff can pick
      # up on a nonuniversal xz and fail
      # https://github.com/Homebrew/homebrew/issues/22732
      "--without-liblzma",
      "--with-libpng",
      "--with-zlib",
      "--enable-dnd",
      "--enable-clipboard",
      "--enable-webkit",
      "--enable-svg",
      "--enable-mediactrl",
      "--enable-graphics_ctx",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--with-expat",
      "--with-macosx-version-min=#{MacOS.version}",
      "--with-macosx-sdk=#{MacOS.sdk_path}",
      "--enable-universal_binary=#{Hardware::CPU.universal_archs.join(',')}",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic"
    ]

    system "./configure", *args
    system "make install"
  end
end
