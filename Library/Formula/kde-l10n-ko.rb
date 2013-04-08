require 'base_kde_formula'

class KdeL10nKo < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ko-4.10.2.tar.xz'
  sha1 'ff81fa02c8884249a52805806185a57e288c09da'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ko-4.10.2.tar.xz'
    sha1 'ff81fa02c8884249a52805806185a57e288c09da'
  end

  depends_on 'kdelibs'
end
