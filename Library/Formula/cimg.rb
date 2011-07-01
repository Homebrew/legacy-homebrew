require 'formula'

class Cimg < Formula
  url 'http://downloads.sourceforge.net/cimg/CImg-1.4.7.zip'
  homepage 'http://cimg.sourceforge.net/'
  sha1 '2c7a86537601a3051ff27f9111811f66b03aa8e9'

  def install
    include.install ['CImg.h']

    doc.install %w(
      README.txt CHANGES.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
