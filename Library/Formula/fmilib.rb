class Fmilib < Formula
  desc "FMI Library enables integration of Functional Mock-up Units (FMUs)"
  homepage "http://www.jmodelica.org/FMILibrary"
  url "http://www.jmodelica.org/downloads/FMIL/FMILibrary-2.0.1-src.zip"
  sha256 "2b82ad1bbb54399ef595755ca9e12e678e8d1ad0e227609d478d9934a298cc43"
  head "https://svn.jmodelica.org/FMILibrary/trunk"

  option "with-debug", "Build with debugging symbols"

  depends_on "cmake" => :build

  def install
    args = %W[
      -DFMILIB_INSTALL_PREFIX=#{prefix}
    ]
    if build.with? "debug"
      args << "-DFMILIB_DEFAULT_BUILD_TYPE_RELEASE=false"
    end
    ENV.cxx11 if MacOS.version < :mavericks

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <fmilib.h>
      #include <fmilib_config.h>
      int main()
      {
        const char* platform = fmi1_get_platform();
        return platform ? 0 : -1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfmilib", "-o", "test"
    system "./test"
  end
end
