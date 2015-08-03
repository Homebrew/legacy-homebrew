class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "http://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.1-Source.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libs/libsoxr/libsoxr_0.1.1.orig.tar.xz"
  sha256 "dcc16868d1a157079316f84233afcc2b52dd0bd541dd8439dc25bceb306faac2"

  bottle do
    cellar :any
    sha1 "fd37418f49d09be7dea842f263c0f781ecc65a14" => :yosemite
    sha1 "0fff9937e8254d636aaa7e0afb1d311a1fbff0e3" => :mavericks
    sha1 "1da33c9683edeaa55a5d79dc08efd40e79a13b53" => :mountain_lion
  end

  depends_on "cmake" => :build

  conflicts_with "sox", :because => "Sox contains soxr. Soxr is purely the resampler."

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
