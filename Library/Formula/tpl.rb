require "formula"

class Tpl < Formula
  homepage "http://troydhanson.github.io/tpl/"
  url "https://github.com/troydhanson/tpl/archive/v1.6.tar.gz"
  sha1 "b7d16e9bcda16d86a5dd2d0af0ab90f7e85aa050"
  head "https://github.com/troydhanson/tpl.git"

  option 'tests', 'Verify the build using the test suite.'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def patches
    DATA
  end

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    
    if build.include? 'tests'
      cd "tests" do
        ohai "Running test suite"
        system "make"
        if $?.exitstatus == 0
          ohai "Test suite succeeded"
        else
          opoo "Test suite failed"
        end
      end
    end
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 6367764..e114a9b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@ AC_INIT([libtpl], [1.4], [tdh@tkhanson.net])
 AC_CONFIG_SRCDIR(src/tpl.c)
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_HEADERS(config/config.h)
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([foreign])
 AC_PROG_CC
 dnl next 4 lines are a hack to avoid libtool's
 dnl needless checks for C++ and Fortran compilers
