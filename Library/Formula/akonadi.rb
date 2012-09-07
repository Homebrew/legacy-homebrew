require 'base_kde_formula'

class Akonadi < BaseKdeFormula
  homepage 'http://pim.kde.org/akonadi/'
  url 'ftp://ftp.kde.org/pub/kde/stable/akonadi/src/akonadi-1.7.1.tar.bz2'
  md5 '54e0556d73c22c7b3393069071e0b717'

  depends_on 'shared-mime-info'
  depends_on 'mysql'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'

  def patches
    {:p0 => [
      "http://bugsfiles.kde.org/attachment.cgi?id=69519"
    ]}
  end
  
end
