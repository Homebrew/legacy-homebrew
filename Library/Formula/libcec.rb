class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "http://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/libcec-3.0.1.tar.gz"
  sha256 "7e3670c8949a1964d6e5481f56dfff838857da10bdc60b506f6e9b7f117e253e"

  bottle do
    cellar :any
    sha1 "d80df26b65e04fdc1a4a6ba2801e54231d9b7be7" => :yosemite
    sha1 "9344093a4180a7f5d0e066ba4b50f301fd1e80b1" => :mavericks
    sha1 "5b04eb4b157c34ab543082a9c9c0868450412c37" => :mountain_lion
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
        system "make install"
      end
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make install"
    end
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end
