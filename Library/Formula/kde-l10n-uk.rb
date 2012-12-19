require 'base_kde_formula'

class Kde-l10n-uk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-uk-4.9.4.tar.xz'
  sha1 'e66205651512a6b10fa8da81523a8fb81c54d75c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-uk-4.9.95.tar.xz'
    sha1 '46a567f8413335bf17a5a43b38d8895aa52ee8af'
  end

  depends_on 'kdelibs'
end
