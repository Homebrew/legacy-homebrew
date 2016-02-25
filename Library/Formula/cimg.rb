class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_1.6.9.zip"
  sha256 "857988d2b4e36989342f475d55f4e3044243831f9fb5d65667de7ab6217a0e04"

  bottle do
    cellar :any
    sha256 "c803b97ca97c11b2adbdda5388c081302a8cb8f543156b63e2897abc5fab4fac" => :yosemite
    sha256 "0adb11f01b9433ee8a8b0754cb2dcb894c65c2c28cc4d15425d159349c6ebef5" => :mavericks
    sha256 "2570664e1c28fb05a59b09d566516d7e9429729cd7268dceb8d9b539770ccdb6" => :mountain_lion
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
