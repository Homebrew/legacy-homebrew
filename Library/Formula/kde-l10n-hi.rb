require 'base_kde_formula'

class KdeL10nHi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-hi-4.10.2.tar.xz'
  sha1 '673d290ac76bf7a757b9441d79926504bf16865b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-hi-4.10.2.tar.xz'
    sha1 '673d290ac76bf7a757b9441d79926504bf16865b'
  end

  depends_on 'kdelibs'
end
