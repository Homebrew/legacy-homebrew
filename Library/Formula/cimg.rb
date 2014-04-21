require 'formula'

class Cimg < Formula
  homepage 'http://cimg.sourceforge.net/'
  url 'https://downloads.sourceforge.net/cimg/CImg-1.5.8.zip'
  sha1 '0c2c5a4ed8656bb9a1319834a4d9a37129aa5d90'

  def install
    include.install 'CImg.h'

    doc.install %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
