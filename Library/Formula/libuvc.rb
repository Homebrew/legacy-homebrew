class Libuvc < Formula
  desc "Cross-platform library for USB video devices"
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha256 "62652a4dd024e366f41042c281e5a3359a09f33760eb1af660f950ab9e70f1f7"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    revision 1
    sha256 "cfb92d3277e90897153ddd3e64f2fecd5330c1b8656b9dfcd7864641988d12ac" => :yosemite
    sha256 "fba52081f76397aab2520f7d56e09b12a78e54b8606587a45ec12305dd03407d" => :mavericks
    sha256 "cca1e796069a44f26f64b935e371bb28c40121270f55b3cca82cbf7ef4586f6f" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "jpeg" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
