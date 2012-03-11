require 'base_kde_formula'

class Ukaccessible < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kaccessible-4.8.1.tar.xz'
  sha1 'da137f22a8de55858a3ae80f4e95d89c18b50257'

  depends_on 'kdelibs'
end


