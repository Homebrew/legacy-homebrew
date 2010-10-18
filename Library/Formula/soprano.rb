require 'formula'

class Soprano <Formula
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.5.2/soprano-2.5.2.tar.bz2'
  homepage 'http://soprano.sourceforge.net/'
  md5 'c5562bae458cad6f5d4f344277a9a48a'

  depends_on 'cmake' => :build
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
