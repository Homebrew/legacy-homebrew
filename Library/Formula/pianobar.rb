require 'formula'

class Pianobar <Formula
  head 'git://github.com/PromyLOPh/pianobar.git'
  url 'http://github.com/PromyLOPh/pianobar/tarball/master'
  version '2a1e81927ef6fbf0d9c5'
  homepage 'http://github.com/PromyLOPh/pianobar/'
  md5 '889c659210f89b5467c655449f09100b'

 depends_on 'cmake'
 depends_on 'libao'
 depends_on 'mad'
 depends_on 'faad2'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
