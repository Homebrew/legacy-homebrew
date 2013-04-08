require 'base_kde_formula'

class KdeL10nSk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sk-4.10.2.tar.xz'
  sha1 '944f3e93396900f32da8af2f472a41e31ab82068'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sk-4.10.2.tar.xz'
    sha1 '944f3e93396900f32da8af2f472a41e31ab82068'
  end

  depends_on 'kdelibs'
end
