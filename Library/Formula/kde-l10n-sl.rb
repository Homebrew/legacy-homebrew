require 'base_kde_formula'

class KdeL10nSl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-sl-4.9.4.tar.xz'
  sha1 'ce4ae940b083a00425dbc18c0611ca49079c3f78'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-sl-4.9.95.tar.xz'
    sha1 'ccc227b098f26ea76551c4b1210ee4a4fdc252c3'
  end

  depends_on 'kdelibs'
end
