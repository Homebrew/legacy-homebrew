require 'base_kde_formula'

class Klines < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/klines-4.10.2.tar.xz'
  sha1 'e8bb9a43ca3207f961bcae60312af37f226d7ec0'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/klines-4.10.2.tar.xz'
    sha1 'e8bb9a43ca3207f961bcae60312af37f226d7ec0'
  end

  depends_on 'kdelibs'
end
