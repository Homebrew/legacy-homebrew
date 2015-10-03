class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "http://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.0.9.tar.gz"
  sha256 "27c81e691c15753cd2b560c2ca4bd5679a60c2350eedd43c99d44ca25d65ea7f"

  head "https://github.com/imageworks/OpenColorIO.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on :python => :optional

  option "with-tests", "Verify the build with its unit tests (~1min)"
  option "with-java", "Build ocio with java bindings"
  option "with-docs", "Build the documentation"

  # Fix build with libc++
  patch do
    url "https://github.com/imageworks/OpenColorIO/commit/ebd6efc036b6d0b17c869e3342f17f9c5ef8bbfc.diff"
    sha256 "eab670cdd0278c610ecd6c059cb12f3042395d474259ddd18b7b8e242ad82810"
  end

  # Fix includes on recent Clang; reported upstream:
  # https://github.com/imageworks/OpenColorIO/issues/338#issuecomment-36589039
  patch :DATA

  def install
    args = std_cmake_args
    args << "-DOCIO_BUILD_JNIGLUE=ON" if build.with? "java"
    args << "-DOCIO_BUILD_TESTS=ON" if build.with? "tests"
    args << "-DOCIO_BUILD_DOCS=ON" if build.with? "docs"
    args << "-DCMAKE_VERBOSE_MAKEFILE=OFF"

    # Python note:
    # OCIO's PyOpenColorIO.so doubles as a shared library. So it lives in lib, rather
    # than the usual HOMEBREW_PREFIX/lib/python2.7/site-packages per developer choice.
    args << "-DOCIO_BUILD_PYGLUE=OFF" if build.without? "python"

    args << ".."

    mkdir "macbuild" do
      system "cmake", *args
      system "make"
      system "make test" if build.with? "tests"
      system "make", "install"
    end
  end

  def caveats
    <<-EOS.undent
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:

          #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:

          http://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:

          http://opencolorio.org/downloads.html
    EOS
  end
end

__END__
diff --git a/export/OpenColorIO/OpenColorIO.h b/export/OpenColorIO/OpenColorIO.h
index 561ce50..796ca84 100644
--- a/export/OpenColorIO/OpenColorIO.h
+++ b/export/OpenColorIO/OpenColorIO.h
@@ -34,6 +34,7 @@ OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #include <iosfwd>
 #include <string>
 #include <cstddef>
+#include <unistd.h>
 
 #include "OpenColorABI.h"
 #include "OpenColorTypes.h"
