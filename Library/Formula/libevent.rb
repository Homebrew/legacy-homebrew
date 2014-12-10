require "formula"

class Libevent < Formula
  homepage "http://libevent.org"
  url "https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libe/libevent/libevent_2.0.21-stable.orig.tar.gz"
  sha1 "3e6674772eb77de24908c6267c698146420ab699"
  revision 1

  bottle do
    cellar :any
    sha1 "02d25e21d04bdef22de822daf70f13c90147b504" => :yosemite
    sha1 "bbf14123e381177a6423a064ff82b5b3adc3d85a" => :mavericks
    sha1 "b1de9d394f4df8561760e3c34c23bb9b518e372f" => :mountain_lion
  end

  head do
    url "https://github.com/libevent/libevent.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build if build.include? "enable-manpages"
  depends_on "pkg-config" => :build
  depends_on "openssl"

  option :universal
  option "enable-manpages", "Install the libevent manpages (requires doxygen)"

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

  # Enable manpage generation
  patch :DATA if build.include? "enable-manpages"

  def install
    ENV.universal_binary if build.universal?
    ENV.j1
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.include? "enable-manpages"
      system "make doxygen"
      man3.install Dir["doxygen/man/man3/*.3"]
    end
  end
end

__END__
diff --git a/Doxyfile b/Doxyfile
index 5d3865e..1442c19 100644
--- a/Doxyfile
+++ b/Doxyfile
@@ -175,7 +175,7 @@ LATEX_HIDE_INDICES     = NO
 # If the GENERATE_MAN tag is set to YES (the default) Doxygen will 
 # generate man pages
 
-GENERATE_MAN           = NO
+GENERATE_MAN           = YES
 
 # The MAN_EXTENSION tag determines the extension that is added to 
 # the generated man pages (default is the subroutine's section .3)
