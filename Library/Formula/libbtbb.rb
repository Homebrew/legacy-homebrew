class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz"
  version "2015-10-R1"
  sha256 "95f493d379a53ec1134cfb36349cc9aac95d77260db4fdb557313b0dbb5c1d5a"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha256 "71e1cbc33e2e8c779438ea39f90181966a92440f530799fe82416754531f577f" => :el_capitan
    sha256 "3fc5717cf5f2d80235326fb5c427af021d6b6933a355b2e8e53dd07b2e4bbeed" => :yosemite
    sha256 "be962a2c4998c92197de496d9a14c4a5cc13d710c9948575d40c13c5e40262d2" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  # Requires headers OS X doesn't supply.
  resource "libpcap" do
    url "http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz"
    sha256 "7ad3112187e88328b85e46dce7a9b949632af18ee74d97ffc3f2b41fe7f448b0"
  end

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    resource("libpcap").stage do
      system "./configure", "--prefix=#{libexec}/vendor", "--enable-ipv6"
      system "make", "install"
    end

    ENV.prepend_path "PATH", libexec/"vendor/bin"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
