class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-3.1.0.tar.gz"
  sha256 "09109d21a1b03f42c9e341d12600f2e4c41038d640269fa75408e2d36126f921"

  bottle do
    cellar :any
    sha256 "417e766b366a2845b2178c83d1abb56263b1c4a28901ef5dd663ab4f97d644b1" => :el_capitan
    sha256 "b61d3a5aff0a3f7568665192829a77d4d437d382b9ae32b70a558ed6f360848d" => :yosemite
    sha256 "177e2e1b1bbc405d6408797750e5714471614464776457d8324cecbfb70375eb" => :mavericks
  end

  depends_on "cmake" => :build

  needs :cxx11

  resource "p8-platform" do
    url "https://github.com/Pulse-Eight/platform/archive/p8-platform-2.0.1.tar.gz"
    sha256 "e97e45273e90571aa37732cde913b262f5f519c387083645d2557d7189c054cf"
  end

  def install
    ENV.cxx11

    resource("p8-platform").stage do
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end
