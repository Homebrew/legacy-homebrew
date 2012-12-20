require 'base_kde_formula'

class KdeL10nIa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ia-4.9.4.tar.xz'
  sha1 'ce81677eb777e0155da5cfebd64b07584354714f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ia-4.9.95.tar.xz'
    sha1 'd4114da00da3efdde357eb8412a7c3e9df1767de'
  end

  depends_on 'kdelibs'
end
