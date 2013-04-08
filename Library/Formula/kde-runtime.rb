require 'base_kde_formula'

class KdeRuntime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-runtime-4.10.2.tar.xz'
  sha1 'b7f3c3907b8f19dcd975b1724b8ae01c4cae638b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-runtime-4.10.2.tar.xz'
    sha1 'b7f3c3907b8f19dcd975b1724b8ae01c4cae638b'
  end

  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'
  depends_on 'kdelibs'

  def extra_cmake_args
    phonon = Formula.factory 'kde-phonon'
    "-DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib"
  end
end
