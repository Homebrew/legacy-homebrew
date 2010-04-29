require 'formula'

class Pianobar <Formula
  url 'http://download.github.com/PromyLOPh-pianobar-3072c5a.tar.gz'
  version '3072c5a'
  homepage 'http://github.com/PromyLOPh/pianobar/'
  md5 'f3f75c31133934a43e542c04f3bfce49'

 depends_on 'cmake'
 depends_on 'libao'
 depends_on 'mad'
 depends_on 'faad2'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
