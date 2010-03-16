require 'formula'

class SharedDesktopOntologies <Formula
  url 'http://downloads.sourceforge.net/project/oscaf/shared-desktop-ontologies/0.2/shared-desktop-ontologies-0.2.tar.bz2'
  homepage 'http://sourceforge.net/apps/trac/oscaf/'
  md5 '6c004e1c377f768cae5b321bc111876b'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
