class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-3.0.1.tar.gz"
  sha256 "7e3670c8949a1964d6e5481f56dfff838857da10bdc60b506f6e9b7f117e253e"

  bottle do
    sha256 "306d97c80d93ceaf6e2b74cc3da4a969db12bf9d8c6143a485b81f2885aed664" => :yosemite
    sha256 "25b8dd9dc73cf4127ef1f585a164e44f48390edc4904c76c8642c091ce795325" => :mavericks
    sha256 "587fe017014efe02fd31e7f7ada38025e9f05f1788ab4b94c4b172aa7d3310b3" => :mountain_lion
  end

  resource "platform" do
    url "https://github.com/Pulse-Eight/platform/archive/1.0.10.tar.gz"
    sha256 "6ba3239cb1c0a5341efcf9488f4d3dfad8c26d6b2994b2b2247e5a61568ab5cd"
  end

  depends_on "cmake" => :build

  needs :cxx11

  # This patch can be removed with the next release bump
  # https://github.com/Pulse-Eight/libcec/issues/112
  patch do
    url "https://github.com/Pulse-Eight/libcec/commit/2f32a9debc1f148b5dfcfc463480f1432bb71725.diff"
    sha256 "93ae5259fadeb710c5ac70d72955c3be55cf68e589584ee7f520c0b2a7bc8a20"
  end

  def install
    ENV.cxx11

    resource("platform").stage do
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
