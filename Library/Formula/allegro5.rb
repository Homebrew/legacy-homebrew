require 'formula'

class Allegro5 <Formula
  url 'http://sourceforge.net/projects/alleg/files/allegro/5.0.0/allegro-5.0.0.tar.gz'
  homepage 'http://www.allegro.cc'
  md5 '99ef472e2f99972d5e833794bf2f57bf'

  depends_on 'cmake' => :build
  depends_on 'libvorbis' => :optional

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
