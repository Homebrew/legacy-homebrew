require 'base_kde_formula'

class Ukcharselect < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kcharselect-4.8.1.tar.xz'
  sha1 '06888b54f8c139966f327dd1955c25c967d437fb'

  depends_on 'kdelibs'
end


