require 'formula'

class Soprano < Formula
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.7.3/soprano-2.7.3.tar.bz2'
  homepage 'http://soprano.sourceforge.net/'
  md5 '2674ab79c3ec17e4d1b7ecfc76651cd0'

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
