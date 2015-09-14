class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "http://www.ghostscript.com/"

  stable do
    url "http://downloads.ghostscript.com/public/ghostscript-9.16.tar.gz"
    sha256 "746d77280cca8afdd3d4c2c1389e332ed9b0605bd107bcaae1d761b061d1a68d"

    patch :DATA # Uncomment OS X-specific make vars
  end

  bottle do
    sha256 "3939157eb2567f35ee11a3e0bdc5f36658788c25f9e846b1c674b28603a40d4b" => :el_capitan
    sha256 "5bc3b9c563a5f1b35dff4089c426baeb913ec32c2d76f913e214b1a138ec97e4" => :yosemite
    sha256 "bc7d20827ad5fe991c3b05fdd23366907ecdd53a2ccba7653c897948700ef6fb" => :mavericks
    sha256 "b31197b17c3b3d500bbf9d7d9dc7f57046c46869be3f03ee4f41424987a52650" => :mountain_lion
  end

  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "git://git.ghostscript.com/ghostpdl.git", :shallow => false

    resource "djvu" do
      url "git://git.code.sf.net/p/djvu/gsdjvu-git"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Uncomment OS X-specific make vars
    patch do
      url "https://gist.githubusercontent.com/jacknagel/9559501/raw/9709b3234cc888d29f717838650d29e7062da917/gs.patch"
      sha256 "b3c8903c00428f1a065ceda04e3377c3a110ec21bc149547615bc2166cde6163"
    end
  end

  option "with-djvu", "Build drivers for DjVU file format"

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "jbig2dec"
  depends_on "little-cms2"
  depends_on "libpng"
  depends_on :x11 => ["2.7.2", :optional]
  depends_on "djvulibre" if build.with? "djvu"
  depends_on "freetype"

  conflicts_with "gambit-scheme", :because => "both install `gsc` binaries"

  # http://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  # http://djvu.sourceforge.net/gsdjvu.html
  # Can't get 1.8 to compile, but feel free to open PR if you can.
  resource "djvu" do
    url "https://downloads.sourceforge.net/project/djvu/GSDjVu/1.6/gsdjvu-1.6.tar.gz"
    sha256 "6236b14b79345eda87cce9ba22387e166e7614cca2ca86b1c6f0d611c26005df"
  end

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile:
    # https://trac.macports.org/browser/trunk/dports/print/ghostscript/Portfile#L64
    renames = %w[freetype jbig2dec jpeg libpng tiff]
    renames.each { |lib| mv lib, "#{lib}_local" }
  end

  def install
    src_dir = build.head? ? "gs" : "."

    if build.with? "djvu"
      resource("djvu").stage do
        inreplace "gsdjvu.mak", "$(GL", "$(DEV"
        (buildpath+"devices").install "gdevdjvu.c"
        (buildpath+"lib").install "ps2utf8.ps"
        ENV["EXTRA_INIT_FILES"] = "ps2utf8.ps"
        (buildpath/"devices/contrib.mak").open("a") { |f| f.write(File.read("gsdjvu.mak")) }
      end
    end

    cd src_dir do
      move_included_source_copies
      args = %W[
        --prefix=#{prefix}
        --disable-cups
        --disable-compile-inits
        --disable-gtk
        --with-system-libtiff
      ]
      args << "--without-x" if build.without? "x11"

      if build.head?
        system "./autogen.sh", *args
      else
        system "./configure", *args
      end

      # versioned stuff in main tree is pointless for us
      inreplace "Makefile", "/$(GS_DOT_VERSION)", ""

      if build.with? "djvu"
        inreplace "Makefile" do |s|
          s.change_make_var!("DEVICE_DEVS17", "$(DD)djvumask.dev $(DD)djvusep.dev")
        end
      end

      # Install binaries and libraries
      system "make", "install"
      system "make", "install-so"
    end

    (share+"ghostscript/fonts").install resource("fonts")
    (man+"de").rmtree
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match /Hello World!/, shell_output("#{bin}/ps2ascii #{ps}")
  end
end

__END__
diff --git a/base/unix-dll.mak b/base/unix-dll.mak
index ae2d7d8..4f4daed 100644
--- a/base/unix-dll.mak
+++ b/base/unix-dll.mak
@@ -64,12 +64,12 @@ GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE)$(GS_SOEXT)$(SO_LIB_VERSION_SEPARATOR)$(G
 
 
 # MacOS X
-#GS_SOEXT=dylib
-#GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
-#GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
-#GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GS_SOEXT=dylib
+GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
+GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
 #LDFLAGS_SO=-dynamiclib -flat_namespace
-#LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
+LDFLAGS_SO_MAC=-dynamiclib -install_name __PREFIX__/lib/$(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)
 
 GS_SO=$(BINDIR)/$(GS_SONAME)

