class GrOsmosdr < Formula
  desc "Osmocom GNU Radio blocks"
  homepage "https://osmocom.org/projects/sdr/wiki/GrOsmoSDR"
  url "http://cgit.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-0.1.4.tar.xz"
  sha256 "1945d0d98fd4b600cb082970267ec2041528f13150422419cbd7febe2b622721"
  head "git://git.osmocom.org/gr-osmosdr"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "librtlsdr" => :recommended
  depends_on "hackrf" => :optional
  depends_on "libbladerf" => :optional
  depends_on "uhd" => :optional
  depends_on "airspy" => :optional

  patch :DATA

  # gr-osmosdr is known not to compile against CMake >3.3.2 currently.
  # Shamelessly ripped from gnuradio Formula
  resource "cmake" do
    url "https://cmake.org/files/v3.3/cmake-3.3.2.tar.gz"
    sha256 "e75a178d6ebf182b048ebfe6e0657c49f0dc109779170bad7ffcb17463f2fc22"
  end

  # Required for GNU Radio VOLK engine
  # See https://trac.macports.org/ticket/37124
  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def install
    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("cmake").stage do
      args = %W[
        --prefix=#{buildpath}/cmake
        --no-system-libs
        --parallel=#{ENV.make_jobs}
        --datadir=/share/cmake
        --docdir=/share/doc/cmake
        --mandir=/share/man
        --system-zlib
        --system-bzip2
      ]

      # https://github.com/Homebrew/homebrew/issues/45989
      if MacOS.version <= :lion
        args << "--no-system-curl"
      else
        args << "--system-curl"
      end

      system "./bootstrap", *args
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PATH", buildpath/"cmake/bin"

    resource("Cheetah").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    The XML block definitions have been installed to:
      #{share}/gnuradio/grc/blocks/

    It might be necessary to add this to the block search path either in the config file at ~/.gnuradio/config.conf or in the environment variable GRC_BLOCKS_PATH.
    See https://gnuradio.org/redmine/projects/gnuradio/wiki/GNURadioCompanion#Installing-the-XML-Block-Definition for more information.
    EOS
  end

  test do
    Language::Python.each_python(build) do |_, version|
      ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
      system "#{bin}/osmocom_siggen_nogui", "-h"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3d67607..c7d86b8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -203,6 +203,10 @@ add_custom_target(uninstall
 find_package(PythonLibs 2)
 find_package(SWIG)
 
+if(APPLE)
+    set(PYTHON_LIBRARY "-undefined dynamic_lookup")
+endif(APPLE)
+
 if(SWIG_FOUND)
     message(STATUS "Minimum SWIG version required is 1.3.31")
     set(SWIG_VERSION_CHECK FALSE)
