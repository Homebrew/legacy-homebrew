require 'base_kde_formula'

class Attica < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/attica/attica-0.4.1.tar.bz2'
  sha1 'f4962636ec9282c32c4ceaec0c85f92ca5102b60'

  #def std_cmake_parameters
  #  "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None -DCMAKE_FIND_FRAMEWORK=LAST -Wno-dev"
  #end
end
