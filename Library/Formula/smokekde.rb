require 'base_kde_formula'

class Usmokekde < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/smokekde-4.8.1.tar.xz'
  sha1 '680a29725c4b04629befafcd6c74dbc8cc6238f6'

  depends_on 'kdelibs'
end


