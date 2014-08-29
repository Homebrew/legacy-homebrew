require "formula"

class Cimg < Formula
  homepage "http://cimg.sourceforge.net/"
  url "https://downloads.sourceforge.net/cimg/CImg-1.5.9.zip"
  sha1 "bcad203e1836db4882c73923f810cdd69906c896"

  def install
    include.install "CImg.h"

    doc.install %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
