require 'base_kde_formula'

class KdeRuntime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-runtime-4.9.4.tar.xz'
  sha1 '8988c3684c05efc676d1bfe454480f60d75fac3b'

  depends_on 'kde-phonon'
  depends_on 'kdelibs'
  depends_on 'oxygen-icons'
  
  def extra_cmake_args
    phonon = Formula.factory 'kde-phonon'
    "-DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib"
  end

end
