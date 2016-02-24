class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.1-Source.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libs/libsoxr/libsoxr_0.1.1.orig.tar.xz"
  sha256 "dcc16868d1a157079316f84233afcc2b52dd0bd541dd8439dc25bceb306faac2"

  bottle do
    cellar :any
    revision 1
    sha256 "d90c59567b5507610bc93c740cde32d6d67707c4b038b7e93c261282be2c1a30" => :el_capitan
    sha256 "1154e13a305ce25408d3f976d9459ca6d3a044493d87e1b607c68d79408b54c4" => :yosemite
    sha256 "9e507fa80e4d4be8277e7e52245765a25cec712dde6e85aad646bb6ffad27009" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "sox", :because => "Sox contains soxr. Soxr is purely the resampler."

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
