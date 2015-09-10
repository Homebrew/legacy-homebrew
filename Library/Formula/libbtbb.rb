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
  depends_on "libpcap"

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
