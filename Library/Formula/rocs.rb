require 'base_kde_formula'

class Rocs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/rocs-4.9.4.tar.xz'
  sha1 '16cb879c6480340c7cb37622b35010df855f7ce5'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/rocs-4.9.95.tar.xz'
    sha1 '6358268fa2e4472da70c14c01a4081e3087f51aa'
  end

  depends_on 'kdelibs'
end
