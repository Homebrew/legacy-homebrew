class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-3.1.0.tar.gz"
  sha256 "09109d21a1b03f42c9e341d12600f2e4c41038d640269fa75408e2d36126f921"

  bottle do
    sha256 "306d97c80d93ceaf6e2b74cc3da4a969db12bf9d8c6143a485b81f2885aed664" => :yosemite
    sha256 "25b8dd9dc73cf4127ef1f585a164e44f48390edc4904c76c8642c091ce795325" => :mavericks
    sha256 "587fe017014efe02fd31e7f7ada38025e9f05f1788ab4b94c4b172aa7d3310b3" => :mountain_lion
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
