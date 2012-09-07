require 'base_kde_formula'

class Kate < BaseKdeFormula
  homepage 'http://kate-editor.org'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kate-4.8.1.tar.xz'
  sha1 'd5bd513cd2bfefc2d345547115d0cb0a9d3e6143'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
