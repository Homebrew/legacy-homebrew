class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "http://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_009_001.tar.gz"
  sha256 "e2059c34bea2aaca31eb8d3501ce7b535b559775d3050ed5c30946c34146a92e"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "f8da1e24e138f9f19efc7ba7c1040a468d0860a2afedf0e9e098957879935279" => :yosemite
    sha256 "93d052af92640e75ae411c8721ea79e6d1581fffd78a8695b9c38bd95d2c34d6" => :mavericks
    sha256 "252ba91714607cccee3ad1a6917e8efd40c10170f9f1c5ca9a6f21672d26aaf2" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "doxygen" => [:build, :optional]
  depends_on "gpsd" => :optional

  resource "Mako" do
    url "https://pypi.python.org/packages/source/M/Mako/Mako-1.0.2.tar.gz"
    sha256 "2550c2e4528820db68cbcbe668add5c71ab7fa332b7eada7919044bf8697679e"
  end

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("Mako").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_find_devices --help", 1).chomp
  end
end
