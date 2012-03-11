require 'base_kde_formula'

class Ukde-workspace < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kde-workspace-4.8.1.tar.xz'
  sha1 '675df4befd736e770e3029af8d38800c9018e888'

  depends_on 'kdelibs'
end


