require 'formula'

class Falcon <Formula
  url 'http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.6.tgz'
  homepage 'http://www.falconpl.org/'
  md5 '50ea7d97ec7599d6e75a6b8b5b8c685a'

  depends_on 'cmake'

  def install
    system "mkdir build"
    system "cp cmake_build.sample build/cmake_build.cmake"
    system "cmake ../Falcon-0.9.6.6"
    system "make"
    system "make install"
  end
end
