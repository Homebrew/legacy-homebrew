require 'formula'

class Cimg < Formula
  homepage 'http://cimg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/cimg/CImg-1.5.4.zip'
  sha1 '16ce883e0ab57c44f14c7838bda62ad3fd1fecc6'

  def install
    include.install 'CImg.h'

    doc.install %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
