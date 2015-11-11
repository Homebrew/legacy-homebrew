class Libbtbb < Formula
  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2015-09-R2.tar.gz"
  sha256 "35ce44636649163f0d9a4de5905f686470f54c79b408959760db8c8182853161"
  version "2015-09-R2"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  option :universal

  depends_on "cmake" => :build
  depends_on "python"
  depends_on "homebrew/dupes/libpcap"


  bottle do
    cellar :any
    sha1 "e1870ab678e92b9524d3f1ea05862fedc3d196eb" => :yosemite
    sha1 "52071cec084c13a10a08102e391f457d176ecd1d" => :mavericks
    sha1 "3069f205340202284cd8e0ec902d056c4f851bba" => :mountain_lion
  end

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
