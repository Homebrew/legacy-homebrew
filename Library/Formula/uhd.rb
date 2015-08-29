class Uhd < Formula
  desc "Hardware driver for all USRP devices."
  homepage "http://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/release_003_008_005.tar.gz"
  sha256 "e0a36e64bffa7d06ac948fd8fc07ff3ce321e1efc3f7e8604b53e0c3ce842989"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "c1ef5c34f15a2a49ee31ec78a64f2b84b445a23c71722a8045872aaffd092127" => :yosemite
    sha256 "09bc2c3e1cd960106e290d372401403d1117d6afebf8733061fa6e8e91cf69d7" => :mavericks
    sha256 "c7e7164248fc83cd496ca622306b785d2490aea1552c1dc463c247f03297a009" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "doxygen" => [:build, :optional]

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha256 "b8370fce4fbcd6b68b6b36c0fb0f4ec24d6ba37ea22988740f4701536611f1ae"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[Markdown Cheetah]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
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
