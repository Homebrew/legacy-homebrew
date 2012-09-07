require 'base_kde_formula'

class Ukbruch < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kbruch-4.8.1.tar.xz'
  sha1 '477e508294b097d8367f80a65b1be7c60b1f3211'

  depends_on 'kdelibs'
end


