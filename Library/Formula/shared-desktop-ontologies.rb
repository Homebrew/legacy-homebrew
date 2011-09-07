require 'formula'

class SharedDesktopOntologies < Formula
  url 'http://downloads.sourceforge.net/project/oscaf/shared-desktop-ontologies/0.5/shared-desktop-ontologies-0.5.tar.bz2'
  homepage 'http://sourceforge.net/apps/trac/oscaf/'
  md5 '067ec9023c4a48e0d53fb15484d78971'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
