class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "http://www.gecode.org/"
  url "http://www.gecode.org/download/gecode-4.4.0.tar.gz"
  sha256 "430398d6900b999f92c6329636f3855f2d4e985fed420a6c4d42b46bfc97782a"

  bottle do
    cellar :any
    sha256 "a2038d4e65773dadec944dcf2d1d25730590b6c3d4c584253cf0d0a0f3beb173" => :yosemite
    sha256 "ff06aa1e2dd83ac13da3c3a64433ed844e2eb5d74a5ef25d992b8d6369943d44" => :mavericks
    sha256 "83c052f33a9a13f74d4d0b22d9d8d9adf7569d35cecaf626ea5a0b0adc5601f9" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make", "install"
  end
end
