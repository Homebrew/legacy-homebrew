require 'formula'

class Cimg <Formula
  url 'http://downloads.sourceforge.net/cimg/CImg-1.4.7.zip'
  homepage 'http://cimg.sourceforge.net/'
  sha1 '2c7a86537601a3051ff27f9111811f66b03aa8e9'

  def install

    # copy the header file to the include path
    mkdir 'include'
    mv 'CImg.h', 'include'
    prefix.install ['include']

    # create a doc path
    mkdir_p 'share/doc/CImg'
    mv 'README.txt', 'share/doc/CImg'
    mv 'CHANGES.txt', 'share/doc/CImg'
    mv 'Licence_CeCILL-C_V1-en.txt', 'share/doc/CImg'
    mv 'Licence_CeCILL_V2-en.txt', 'share/doc/CImg'
    mv 'html', 'share/doc/CImg'
    mv 'examples', 'share/doc/CImg'
    prefix.install ['share']

  end
end
