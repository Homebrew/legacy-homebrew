require 'base_kde_formula'

class Kde-l10n-nb < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-nb-4.9.4.tar.xz'
  sha1 'f9f347f0e26d96c0198c780641bdc58321317a26'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-nb-4.9.95.tar.xz'
    sha1 '0a4b31831724a17eec8a51d5d91d6c0213d24868'
  end

  depends_on 'kdelibs'
end
