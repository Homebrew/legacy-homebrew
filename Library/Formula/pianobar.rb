require 'formula'

class Pianobar <Formula
  url 'http://github.com/PromyLOPh/pianobar/tarball/d38167c27597a8a114fde0f1fef2a73b3277ba36'
  version 'd38167c'
  homepage 'http://github.com/PromyLOPh/pianobar/'
  md5 'e0922b871404269b73fc295c5468727e'

 depends_on 'cmake'
 depends_on 'libao'
 depends_on 'mad'
 depends_on 'faad2'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
