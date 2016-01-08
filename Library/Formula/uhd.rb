class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "http://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_009_001.tar.gz"
  sha256 "e2059c34bea2aaca31eb8d3501ce7b535b559775d3050ed5c30946c34146a92e"
  head "https://github.com/EttusResearch/uhd.git"
  revision 1

  bottle do
    sha256 "47de60fe5be8c80bc7d471ee782db3055a4b69b0677884a3dd24105097bed177" => :el_capitan
    sha256 "3049b48a4c6539a05a9f79f90028e28c59649374869325d20b8c7fa5f88497ab" => :yosemite
    sha256 "ca1ee5137565c4af4a50cda2ea9c7c8a7b854acb186612cb213eacf6ffd18bf4" => :mavericks
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
