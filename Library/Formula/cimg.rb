require 'formula'

class Cimg < Formula
  homepage 'http://cimg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/cimg/CImg-1.4.9.zip'
  md5 'a07cba03f6d66a9970e0b3fcc230bddc'

  devel do
    url 'http://downloads.sourceforge.net/cimg/CImg-1.5.0_beta.zip'
    md5 'd8b3922bfb5cc2cf7b02cdb0a872054c'
    version "1.5.0-beta"
  end
  
  def options
    [
      ['--devel', 'Install CImg version 1.5.0-beta']
    ]
  end
  
  def install
    include.install 'CImg.h'

    docs = %w(
      README.txt
      Licence_CeCILL-C_V1-en.txt Licence_CeCILL_V2-en.txt
      html examples)
    unless ARGV.build_devel?
      docs << 'CHANGES.txt'
    end
    doc.install docs
    
  end
end
