require 'base_kde_formula'

class KdeRuntime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kde-runtime-4.7.4.tar.bz2'
  md5 '8e6af5f464ae06e3b7cbfd73aa9f7971'

  depends_on 'kde-phonon'
  depends_on 'kdelibs'
  depends_on 'oxygen-icons'
  
  def extra_cmake_args
    phonon = Formula.factory 'kde-phonon'
    "-DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib"
  end

end
