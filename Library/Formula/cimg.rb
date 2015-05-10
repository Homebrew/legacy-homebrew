class Cimg < Formula
  homepage "http://cimg.sourceforge.net/"
  url "https://downloads.sourceforge.net/cimg/CImg_1.6.2.zip"
  sha256 "5c3f465b431566e82d9aeb0ca5dd18d925d3733861c735f4edf7f4e715748813"

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
