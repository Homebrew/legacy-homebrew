require 'formula'

class Gflags < Formula
  homepage "http://code.google.com/p/google-gflags/"
  url "https://github.com/schuhschuh/gflags/archive/v2.1.1.tar.gz"
  sha1 "59b37548b10daeaa87a3093a11d13c2442ac6849"

  bottle do
    cellar :any
    sha1 "a505e4743158a4336b2f4794e724b1f213309aa1" => :yosemite
    sha1 "c7c39cddb08e025e988c2529e60c5641c9d8eef6" => :mavericks
    sha1 "d160e728b0c3cf29cb7ed23afe2f20d38deeef57" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
