class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R29.tar.gz"
  sha256 "5a2e37f3a9a5dc60f55a301b222df75a580ccf319b099a3e421e2334ef8cbde6"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "32a0caee25b2dddf9fec8a95bba6a313b323fc4459340f55969852e8c423db36" => :el_capitan
    sha256 "eed8b170d7fa571ba825ecc0b54fa8b62365a25bd3bf0f4997e339a5d4e70778" => :yosemite
    sha256 "90247e7b2a1fa10587512449d822ea548846ee904ffd26a0dace3e7944de61d5" => :mavericks
  end

  # issue with upstream: https://github.com/vapoursynth/vapoursynth/issues/201
  patch :DATA

  needs :cxx11
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build
  depends_on :python3

  depends_on "zimg"
  depends_on "tesseract"
  depends_on "libass"

  resource "cython" do
    url "https://pypi.python.org/packages/source/C/Cython/Cython-0.21.2.tar.gz"
    sha256 "b01af23102143515e6138a4d5e185c2cfa588e0df61c0827de4257bac3393679"
  end

  def install
    version = Language::Python.major_minor_version("python3")
    ENV.prepend_create_path "PKG_CONFIG_PATH", Pathname.new(`python3-config --prefix`.chomp)/"lib/pkgconfig"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PATH", libexec/"bin"
    resource("cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vspipe", "--version"
    system "python3", "-c", "import vapoursynth"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index 88287a0..dfcaace 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -98,8 +98,8 @@ pyexec_LTLIBRARIES = vapoursynth.la

 vapoursynth_la_SOURCES = src/cython/vapoursynth.pyx
 vapoursynth_la_CPPFLAGS = $(PYTHON3_CFLAGS)
-vapoursynth_la_LIBADD = $(PYTHON3_LIBS) libvapoursynth.la
-vapoursynth_la_LDFLAGS = -no-undefined -avoid-version -module
+vapoursynth_la_LIBADD = libvapoursynth.la
+vapoursynth_la_LDFLAGS = -undefined dynamic_lookup -avoid-version -module
 vapoursynth_la_LIBTOOLFLAGS = $(commonlibtoolflags)

 MOSTLYCLEANFILES = src/cython/vapoursynth.c \
