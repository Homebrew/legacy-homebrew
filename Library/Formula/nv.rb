class Nv < Formula
  desc "Lightweight utility to load context specific environment variables"
  homepage "https://github.com/jcouture/nv"
  url "https://github.com/jcouture/nv/archive/0.0.1.tar.gz"
  sha256 "b48d7fe9d1651fdb5f16e05147d1dc4b70337f0abcd43dfc5e0a89fa97e5a9b7"

  head "https://github.com/jcouture/nv.git"

  bottle do
    sha256 "aaebe29b5cf2bb1f57f7d81c7552be8a31e5f1fd570a74cc5b02b2a1c70d6b78" => :el_capitan
    sha256 "416903e6db83af6e6cd894b255f4dcab2a3c3cc00e96df2fec7ec0ef3316b4fa" => :yosemite
    sha256 "3dcba89c51ad223cc854d85a3354e2222de6925d6d8a161b68e84d1cfae3b54f" => :mavericks
    sha256 "6dcf1ea79a81501016369c342e2f3610e6148b1d0a9831f2896fc5380ab21654" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "-o", "nv"
    bin.install "nv"
  end

  test do
    system "#{bin}/nv"
  end
end
