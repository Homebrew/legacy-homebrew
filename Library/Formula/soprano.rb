require 'formula'

class Soprano <Formula
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.4.1/soprano-2.4.1.tar.bz2'
  homepage 'http://soprano.sourceforge.net/'
  md5 '4892c800853cc340b63d0ab6fcf405af'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'clucene' => :optional
  depends_on 'raptor' => :optional
  depends_on 'redland' => :optional

  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX

    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
