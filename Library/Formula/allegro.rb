require 'formula'

class Allegro < Formula
  url 'http://downloads.sourceforge.net/project/alleg/allegro/5.0.1/allegro-5.0.1.tar.gz'
  homepage 'http://www.allegro.cc'
  md5 '7a7dafa3362b97dd653f736e21f5ef21'

  depends_on 'cmake' => :build
  depends_on 'libvorbis' => :optional

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
