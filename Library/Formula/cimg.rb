require 'formula'

class Cimg < Formula
  url 'http://downloads.sourceforge.net/cimg/CImg-1.4.9.zip'
  homepage 'http://cimg.sourceforge.net/'
  md5 'a07cba03f6d66a9970e0b3fcc230bddc'

  def install
    include.install ['CImg.h']

    doc.install %w(
      README.txt CHANGES.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
  end
end
