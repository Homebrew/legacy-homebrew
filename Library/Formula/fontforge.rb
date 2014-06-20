require 'formula'

class Fontforge < Formula
  homepage 'http://fontforge.org/'
  revision 1

  stable do
    url 'https://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20120731-b.tar.bz2'
    sha1 'b520f532b48e557c177dffa29120225066cc4e84'

    depends_on 'cairo' => :optional
    depends_on 'pango' => :optional

    # Fixes double defined AnchorPoint on Mountain Lion 10.8.2
    patch do
      url "https://gist.githubusercontent.com/rubenfonseca/5078149/raw/98a812df4e8c50d5a639877bc2d241e5689f1a14/fontforge"
      sha1 "baa7d60f4c6e672180e66438ee675b4ee0fda5ce"
    end
  end

  bottle do
    sha1 "62e19f688ec4fbd4a6263c6187980c35521a7b40" => :mavericks
    sha1 "5edf50ab049d44ff399defe673faa58d136c54d3" => :mountain_lion
    sha1 "8b38be9b20ce239e63f3f3009482ab8f130c0a33" => :lion
  end

  head do
    url 'https://github.com/fontforge/fontforge.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on 'pkg-config' => :build
    depends_on 'glib'
    depends_on 'pango'
    depends_on 'cairo'
    depends_on 'ossp-uuid'
  end

  option 'with-gif', 'Build with GIF support'
  option 'with-x', 'Build with X11 support, including FontForge.app'

  depends_on 'gettext'
  depends_on :python => :optional

  depends_on 'libpng'   => :recommended
  depends_on 'jpeg'     => :recommended
  depends_on 'libtiff'  => :recommended
  depends_on :x11 if build.with? 'x'
  depends_on 'giflib' if build.with? 'gif'
  depends_on 'libspiro' => :optional
  depends_on 'czmq'=> :optional
  depends_on 'fontconfig'

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-double",
            "--without-freetype-bytecode"]

    unless build.head?
      # These are optional in the stable release, but required in head
      args << "--without-cairo" if build.without? "cairo"
      args << "--without-pango" if build.without? "pango"
    end
    args << "--without-x" if build.without? 'x'

    # To avoid "dlopen(/opt/local/lib/libpng.2.dylib, 1): image not found"
    args << "--with-static-imagelibs"

    if build.with? 'python'
      args << "--enable-pyextension"
      # Fix linking to correct Python library
      ENV.prepend "LDFLAGS", "-L#{%x(python-config --prefix).chomp}/lib"
    else
      args << "--without-python"
    end

    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # Add environment variables for system libs if building head
    if build.head?
      ENV.append "ZLIB_CFLAGS", "-I/usr/include"
      ENV.append "ZLIB_LIBS", "-L/usr/lib -lz"
    end

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    # Set up framework paths so FlatCarbon replacement paths work (see below)
    ENV.append "CFLAGS", "-F#{MacOS.sdk_path}/System/Library/Frameworks/CoreServices.framework/Frameworks"
    ENV.append "CFLAGS", "-F#{MacOS.sdk_path}/System/Library/Frameworks/Carbon.framework/Frameworks"

    system "./autogen.sh" if build.head?
    system "./configure", *args

    # Fix hard-coded install locations that don't respect the target bindir
    inreplace "Makefile" do |s|
      s.gsub! "/Applications", "$(prefix)"
      s.gsub! "ln -s /usr/local/bin/fontforge", "ln -s $(bindir)/fontforge"
    end

    # Fix install location of Python extension; see:
    # http://sourceforge.net/mailarchive/message.php?msg_id=26827938
    inreplace "Makefile" do |s|
      s.gsub! "python setup.py install --prefix=$(prefix) --root=$(DESTDIR)", "python setup.py install --prefix=$(prefix)"
    end

    # Replace FlatCarbon headers with the real paths
    # Fixes building on 10.8
    # Only needed for non-head build
    unless build.head?
      inreplace %w(fontforge/macbinary.c fontforge/startui.c gutils/giomime.c) do |s|
        s.gsub! "/Developer/Headers/FlatCarbon/Files.h", "CarbonCore/Files.h"
      end
      inreplace %w(fontforge/startui.c) do |s|
        s.gsub! "/Developer/Headers/FlatCarbon/CarbonEvents.h", "HIToolbox/CarbonEvents.h"
      end
    end

    system "make"
    system "make install"
  end

  test do
    system "#{bin}/fontforge", "-version"
  end
end
