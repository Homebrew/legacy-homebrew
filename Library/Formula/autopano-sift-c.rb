class AutopanoSiftC < Formula
  desc "Find control points in overlapping image pairs"
  homepage "http://wiki.panotools.org/Autopano-sift-C"
  url "https://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz"
  sha256 "9a9029353f240b105a9c0e31e4053b37b0f9ef4bd9166dcb26be3e819c431337"

  depends_on "libpano"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /Version #{Regexp.escape(version)}/,
                 pipe_output("#{bin}/autopano-sift-c")
  end
end
