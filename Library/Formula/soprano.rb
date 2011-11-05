require 'formula'

class Soprano < Formula
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.6.0/soprano-2.6.0.tar.bz2'
  homepage 'http://soprano.sourceforge.net/'
  md5 '03ae49e87c6ec99e57d0433c2650846f'

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
