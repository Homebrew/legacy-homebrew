require "formula"

class Openbr < Formula
  homepage "http://www.openbiometrics.org/"
  url "https://github.com/biometrics/openbr/releases/download/v0.4.1/openbr0.4.1_withModels.tar.gz"
  sha1 "1cf3b9b6fad1c717d8b0256b3a22d138510572e9"

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "opencv"
  depends_on "eigen"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/br", "-version"
  end
end
