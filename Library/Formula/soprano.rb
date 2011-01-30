require 'formula'

class Soprano <Formula
  url 'http://sourceforge.net/projects/soprano/files/Soprano/2.5.63/soprano-2.5.63.tar.bz2'
  homepage 'http://soprano.sourceforge.net/'
  md5 'bef6147f1245cd99aa9ad1a37f7d48ac'

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
