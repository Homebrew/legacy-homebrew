require 'base_kde_formula'

class Strigi < BaseKdeFormula
  homepage 'http://strigi.sourceforge.net/'
  url 'http://www.vandenoever.info/software/strigi/strigi-0.7.5.tar.bz2'
  md5 '0559e2ab65d187d30916e9ffe36e0fb6'

  depends_on 'clucene'
  #depends_on 'ffmpeg'
  depends_on 'exiv2' => :optional

  def extra_cmake_args
    "-DENABLE_EXPAT:BOOL=ON -DENABLE_DBUS:BOOL=OFF"
  end
  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX
    ENV['EXPAT_HOME'] = '/usr/'

    default_install
  end
end
