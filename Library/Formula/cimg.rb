require 'formula'

class Cimg < Formula
  homepage 'http://cimg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/cimg/CImg-1.5.6.zip'
  sha1 '073391c2bf3ade2c1c3c663a790e774f344dea3d'

  def install
    include.install 'CImg.h'

    doc.install %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
