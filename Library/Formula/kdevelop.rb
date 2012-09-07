require 'base_kde_formula'

class Kdevelop < BaseKdeFormula
  homepage 'http://kdevelop.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/kdevelop/4.2.3/src/kdevelop-4.2.3.tar.bz2'
  md5 '8b6e59764612314e6776edb3386c0930'
  depends_on 'kdelibs'
  depends_on 'kdevplatform'
  depends_on 'kdevelop-php'
  depends_on 'kdevelop-php-docs'
end

