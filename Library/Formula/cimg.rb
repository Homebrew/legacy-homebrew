require 'formula'

class Cimg <Formula
  url 'http://downloads.sourceforge.net/cimg/CImg-1.4.7.zip'
  homepage 'http://cimg.sourceforge.net/'
  sha1 '2c7a86537601a3051ff27f9111811f66b03aa8e9'

  def install

    # copy the header file to the include path
    include.install ['CImg.h']

    # create a doc path
    doc.install ['README.txt']
    doc.install ['CHANGES.txt']
    doc.install ['Licence_CeCILL-C_V1-en.txt']
    doc.install ['Licence_CeCILL_V2-en.txt']
    doc.install ['html']
    doc.install ['examples']

  end
end
