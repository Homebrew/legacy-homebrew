require 'formula'

class Allegro <Formula
  url 'http://downloads.sourceforge.net/project/alleg/allegro/4.4.1.1/allegro-4.4.1.1.tar.gz'
  homepage 'http://www.allegro.cc'
  md5 '0f1cfff8f2cf88e5c91a667d9fd386ec'

  depends_on 'cmake' => :build
  depends_on 'libvorbis' => :optional

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
