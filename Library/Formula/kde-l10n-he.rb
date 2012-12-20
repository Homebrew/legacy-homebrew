require 'base_kde_formula'

class KdeL10nHe < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-he-4.9.4.tar.xz'
  sha1 '17dbd35c2776b5279912497595b931c0ca50ca44'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-he-4.9.95.tar.xz'
    sha1 'ecd1ef3a7f54aebde7e1cb0994646939971d0b04'
  end

  depends_on 'kdelibs'
end
