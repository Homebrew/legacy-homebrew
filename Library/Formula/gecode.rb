class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "http://www.gecode.org/"
  url "http://www.gecode.org/download/gecode-4.4.0.tar.gz"
  sha256 "430398d6900b999f92c6329636f3855f2d4e985fed420a6c4d42b46bfc97782a"

  bottle do
    cellar :any
    sha256 "4df88b3f67a4d188f00883f182f3893b9df99b90637635abf18441ebfbeb0c9c" => :yosemite
    sha256 "b48b0a8755542484f5eeb5647e41db0824cfb769060c28c118df6267fa98aaab" => :mavericks
    sha256 "a6cf500df618c42f0668bb227c090e6c1d3d3369c8b4537220d3deb78d5f8286" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make", "install"
  end
end
