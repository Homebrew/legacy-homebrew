class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz"
  version "2015-10-R1"
  sha256 "95f493d379a53ec1134cfb36349cc9aac95d77260db4fdb557313b0dbb5c1d5a"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha1 "e1870ab678e92b9524d3f1ea05862fedc3d196eb" => :yosemite
    sha1 "52071cec084c13a10a08102e391f457d176ecd1d" => :mavericks
    sha1 "3069f205340202284cd8e0ec902d056c4f851bba" => :mountain_lion
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
