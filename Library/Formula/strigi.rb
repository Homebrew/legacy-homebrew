require 'formula'

class Strigi <Formula
  url 'http://www.vandenoever.info/software/strigi/strigi-0.7.2.tar.bz2'
  homepage 'http://strigi.sourceforge.net/'
  md5 'ca09ba176cf3ffe9afce4d92f38f9a85'

  depends_on 'cmake' => :build
  depends_on 'clucene'
  depends_on 'exiv2' => :optional

  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX
    ENV['EXPAT_HOME'] = '/usr/'

    system "cmake . #{std_cmake_parameters} -DENABLE_EXPAT:BOOL=ON -DENABLE_DBUS:BOOL=OFF"
    system "make install"
  end
end
