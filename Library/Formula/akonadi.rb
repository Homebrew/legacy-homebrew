require 'base_kde_formula'

class Akonadi < BaseKdeFormula
  homepage 'http://pim.kde.org/akonadi/'
  url 'ftp://ftp.kde.org/pub/kde/stable/akonadi/src/akonadi-1.9.1.tar.bz2'
  sha1 '955ea3ccca2c81db8b81deea9a45921c89687bda'

  depends_on 'shared-mime-info'
  depends_on 'mysql'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'

  #def patches
  #  {:p0 => [
  #    "http://bugsfiles.kde.org/attachment.cgi?id=69519"
  #  ]}
  #end
  
end
