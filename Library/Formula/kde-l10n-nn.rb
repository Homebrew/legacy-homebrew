require 'base_kde_formula'

class KdeL10nNn < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-nn-4.9.4.tar.xz'
  sha1 'a18f2a2f5f189d8883441acfa22a4982f25fccad'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-nn-4.9.95.tar.xz'
    sha1 '82ad4da16d9533eb443fe36811de8387fca00b23'
  end

  depends_on 'kdelibs'
end
