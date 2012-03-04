require 'base_kde_formula'

class Kate < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/kate-4.8.0.tar.bz2'
  homepage 'http://kate-editor.org'
  #md5 '565ebff0d1e2316097897149eeb4d255'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
