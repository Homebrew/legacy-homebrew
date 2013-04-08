require 'base_kde_formula'

class KdeL10nLt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-lt-4.10.2.tar.xz'
  sha1 '0f08de2146faaa3a7810d2107e9ba83bee7c8dd6'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-lt-4.10.2.tar.xz'
    sha1 '0f08de2146faaa3a7810d2107e9ba83bee7c8dd6'
  end

  depends_on 'kdelibs'
end
