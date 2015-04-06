require "formula"

class Cimg < Formula
  homepage "http://cimg.sourceforge.net/"
  url "https://downloads.sourceforge.net/cimg/CImg_1.6.1.zip"
  sha1 "b5bac348c4eeaef6b68d17e2314f42642994005a"

  def install
    include.install "CImg.h"

    doc.install %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      examples)
  end
end
