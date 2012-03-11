require 'base_kde_formula'

class KdeRuntime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kde-runtime-4.8.1.tar.xz'
  sha1 '82b57dc38335716fb382a665b536a9aece4684d6'

  depends_on 'kde-phonon'
  depends_on 'kdelibs'
  depends_on 'oxygen-icons'
  
  def extra_cmake_args
    phonon = Formula.factory 'kde-phonon'
    "-DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib"
  end

end
