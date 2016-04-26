class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_1.6.9.zip"
  sha256 "857988d2b4e36989342f475d55f4e3044243831f9fb5d65667de7ab6217a0e04"

  bottle do
    cellar :any_skip_relocation
    sha256 "4279078a6e13098070cc62632596a0f2187115eab197fc093eca49f8c57d175a" => :el_capitan
    sha256 "df6f99dab3ac2e1046e891d2594d9e9845d4b2164421bd4fccebf50d4a74e0cf" => :yosemite
    sha256 "066d8e2062bf9b0cfb7b0ff4a4edf24c55e5fdaecb8cf262e549081c281f2fe5" => :mavericks
  end

  def install
    include.install "CImg.h"

    doc.install %w[
      README.txt
      Licence_CeCILL-C_V1-en.txt
      Licence_CeCILL_V2-en.txt
      examples
      plugins
    ]
  end

  test do
    cp_r doc/"examples", testpath
    cp_r doc/"plugins", testpath
    system "make", "-C", "examples", "mmacosx"
    system "examples/image2ascii"
  end
end
