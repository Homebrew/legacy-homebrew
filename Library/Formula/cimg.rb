require 'formula'

class Cimg < Formula
  homepage 'http://cimg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/cimg/CImg-1.5.0.zip'
  md5 '0a9ce7fb504ca3d9ac9ca99914b02de6'

  def install
    include.install 'CImg.h'

    doc.install %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
