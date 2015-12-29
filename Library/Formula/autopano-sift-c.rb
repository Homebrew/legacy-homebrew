class AutopanoSiftC < Formula
  desc "Find control points in overlapping image pairs"
  homepage "http://wiki.panotools.org/Autopano-sift-C"
  url "https://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz"
  sha256 "9a9029353f240b105a9c0e31e4053b37b0f9ef4bd9166dcb26be3e819c431337"

  bottle do
    cellar :any
    sha256 "325d74775797dfe0cdc0c6b6e0255166fe7573b4648c20758adf1386c2c85991" => :el_capitan
    sha256 "929174dc5dd8b519136154249df83e026ac9c234988a979a592d03c47477988b" => :yosemite
    sha256 "5a777245c630a0d91178d347f3e452b7d9784c7d7ff15f9fa4ed12d9bdc2830c" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libpano"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", pipe_output("#{bin}/autopano-sift-c")
  end
end
