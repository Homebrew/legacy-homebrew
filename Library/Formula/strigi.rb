require 'brewkit'

class Strigi <Formula
  @url='http://surfnet.dl.sourceforge.net/project/strigi/strigi/strigi-0.6.4/strigi-0.6.4.tar.bz2'
  @homepage='http://strigi.sourceforge.net/'
  @md5='324fd9606ac77765501717ff92c04f9a'

  depends_on 'cmake'
  depends_on 'CLucene'

  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX
    ENV['EXPAT_HOME'] = '/usr/'

    system "cmake . #{std_cmake_parameters} -DENABLE_EXPAT:BOOL=ON"
    system "make install"
  end
end
