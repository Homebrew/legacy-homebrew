class Crfxx < Formula
  desc "Conditional random fields for segmenting/labeling sequential data"
  homepage "https://taku910.github.io/crfpp/"
  url "https://drive.google.com/uc?id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ&export=download"
  version "0.58"
  sha256 "9d1c0a994f25a5025cede5e1d3a687ec98cd4949bfb2aae13f2a873a13259cb2"

  bottle do
    cellar :any
    sha256 "b7444b7e7f651de0b52380cf30f6dfef6c8bd6a3a6c5c35b443445fc0a167ea4" => :el_capitan
    sha256 "b9e568fb68ed439cccd55328c9cb75b8add196cd6c34698acaabeb47192bc16f" => :yosemite
    sha256 "75934a3f7d521f848653533c6e597478e942d720117e195477b836f0976c0b6d" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end

  test do
    # Using "; true" because crf_test -v and -h exit nonzero under normal operation
    assert_match "CRF++: Yet Another CRF Tool Kit", shell_output("crf_test --help; true")
  end
end
