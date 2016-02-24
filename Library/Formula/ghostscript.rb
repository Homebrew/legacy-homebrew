class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "http://www.ghostscript.com/"

  stable do
    url "http://downloads.ghostscript.com/public/ghostscript-9.18.tar.gz"
    sha256 "5fc93079749a250be5404c465943850e3ed5ffbc0d5c07e10c7c5ee8afbbdb1b"

    patch do
      url "https://github.com/Homebrew/patches/raw/master/ghostscript/bug-696301_gserrors.h.patch"
      sha256 "1639d20605693dd473399dc2ebc838442175a8f7e6eb7701fbe08e12b57bee18"
    end
  end

  bottle do
    sha256 "79f767cdf9e5eea94e0e9d0e88099ac2da1cf628baec948365456339d29cba25" => :el_capitan
    sha256 "cf505ec93d681055aa97a08fb868c59d2344067feec457721b8b9d2d4c6ebe5a" => :yosemite
    sha256 "1eb83d2677c5d33098223571fae553e6ccd5ef47c5b1a7bb7cc093906e2ac5d2" => :mavericks
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
  end

  patch :DATA # Uncomment OS X-specific make vars

  option "with-djvu", "Build drivers for DjVU file format"

  depends_on "pkg-config" => :build
  depends_on "djvulibre" if build.with? "djvu"
  depends_on "little-cms2"
  depends_on :x11 => :optional

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

  def install
    if build.with? "djvu"
      resource("djvu").stage do
        inreplace "gsdjvu.mak", "$(GL", "$(DEV"
        (buildpath+"devices").install "gdevdjvu.c"
        (buildpath+"lib").install "ps2utf8.ps"
        ENV["EXTRA_INIT_FILES"] = "ps2utf8.ps"
        (buildpath/"devices/contrib.mak").open("a") { |f| f.write(File.read("gsdjvu.mak")) }
      end
    end

    args = %W[
      --prefix=#{prefix}
      --disable-cups
      --disable-compile-inits
      --disable-gtk
    ]
    args << "--without-x" if build.without? "x11"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    if build.with? "djvu"
      inreplace "Makefile" do |s|
        s.change_make_var!("DEVICE_DEVS17", "$(DD)djvumask.dev $(DD)djvusep.dev")
      end
    end

    # Install binaries and libraries
    system "make", "install"
    system "make", "install-so"

    (pkgshare/"fonts").install resource("fonts")
    (man/"de").rmtree
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

