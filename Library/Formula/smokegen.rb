require 'base_kde_formula'

class Usmokegen < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/smokegen-4.8.1.tar.xz'
  sha1 '6d43ed064730ff81e1844d0634c1b574bd4ffdb2'

  depends_on 'kdelibs'
end


