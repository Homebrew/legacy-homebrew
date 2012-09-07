require 'base_kde_formula'

class Uklettres < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/klettres-4.8.1.tar.xz'
  sha1 'd26ced07799a849d42e0865c143515934bfb9446'

  depends_on 'kdelibs'
end


