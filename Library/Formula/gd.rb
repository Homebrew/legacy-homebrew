require 'formula'

class Gd < Formula
  homepage 'http://libgd.bitbucket.org/'
  url 'https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.0.tar.gz'
  sha1 'a0f3053724403aef9e126f4aa5c662573e5836cd'

  bottle do
    cellar :any
    sha1 "87bbfcde2e61c0a0ba04fd6e23fd5b74abae254a" => :mavericks
    sha1 "91e5c6ed43c2118dca085f5615dde950bbc5fa56" => :mountain_lion
    sha1 "9c3e0d5b7256a6404e728ea4e10d720d8eb2fab5" => :lion
  end

  head 'https://bitbucket.org/libgd/gd-libgd', :using => :hg

  option :universal

  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on :fontconfig => :optional
  depends_on :freetype => :optional
  depends_on 'libtiff' => :optional
  depends_on 'libvpx' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def png_prefix
    MacOS.version >= :mountain_lion ? HOMEBREW_PREFIX/"opt/libpng" : MacOS::X11.prefix
  end

  def fontconfig_prefix
    MacOS.version >= :mountain_lion ? HOMEBREW_PREFIX/"opt/fontconfig" : MacOS::X11.prefix
  end

  def freetype_prefix
    MacOS.version >= :mountain_lion ? HOMEBREW_PREFIX/"opt/freetype" : MacOS::X11.prefix
  end

  def install
    ENV.universal_binary if build.universal?
    args = %W{--disable-dependency-tracking --prefix=#{prefix}}

    if build.with? "libpng"
      args << "--with-png=#{png_prefix}"
    else
      args << "--without-png"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig=#{fontconfig_prefix}"
    else
      args << "--without-fontconfig"
    end

    if build.with? "freetype"
      args << "--with-freetype=#{freetype_prefix}"
    else
      args << "--without-freetype"
    end

    if build.with? "jpeg"
      args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    else
      args << "--without-jpeg"
    end

    if build.with? "libtiff"
      args << "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    else
      args << "--without-tiff"
    end

    if build.with? "libvpx"
      args << "--with-vpx=#{Formula["libvpx"].opt_prefix}"
    else
      args << "--without-vpx"
    end

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/pngtogd", "/usr/share/doc/cups/images/cups.png", "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
