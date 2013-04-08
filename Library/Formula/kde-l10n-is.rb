require 'base_kde_formula'

class KdeL10nIs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-is-4.10.2.tar.xz'
  sha1 '30219b24465deeb7e86b499a4761695e282a155a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-is-4.10.2.tar.xz'
    sha1 '30219b24465deeb7e86b499a4761695e282a155a'
  end

  depends_on 'kdelibs'
end
