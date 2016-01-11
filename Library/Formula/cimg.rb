class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_1.6.3.zip"
  sha256 "c2a3c62d05d1e322afa6afae086cf96df82a3a13b839e9bf1cedcb014d921ce7"

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
      plugins]
  end

  test do
    cd doc/"examples" do
      system "make", "mmacosx"
    end
  end
end
