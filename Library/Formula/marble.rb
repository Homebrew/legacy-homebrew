require 'base_kde_formula'

class Marble < BaseKdeFormula
  homepage 'http://kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/marble-4.8.1.tar.xz'
  sha1 '542da37f6ea2df21b331aea28cab810eb6802b78'

  depends_on 'kdelibs'
end
