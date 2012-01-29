require 'formula'

class Soprano < Formula
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.7.4/soprano-2.7.4.tar.bz2'
  homepage 'http://soprano.sourceforge.net/'
  md5 '783fb07f9679f45e987aff7a17bef649'

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

