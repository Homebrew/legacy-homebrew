require 'base_kde_formula'

class KdeL10nEu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-eu-4.10.2.tar.xz'
  sha1 '9d1cd7127a7aa36b4aa7c27267cccd2a1e4efbe2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-eu-4.10.2.tar.xz'
    sha1 '9d1cd7127a7aa36b4aa7c27267cccd2a1e4efbe2'
  end

  depends_on 'kdelibs'
end
