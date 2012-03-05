require 'formula'

class Soprano < Formula
  homepage 'http://soprano.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/soprano/Soprano/2.7.5/soprano-2.7.5.tar.bz2'
  md5 '9d881ce405354da4f7c2eeee386e2859'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'clucene' => :optional
  depends_on 'raptor' => :optional
  depends_on 'redland' => :optional

  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX

    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end

