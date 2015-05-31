class Cimg < Formula
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_1.6.3.zip"
  sha256 "c2a3c62d05d1e322afa6afae086cf96df82a3a13b839e9bf1cedcb014d921ce7"

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
