require 'base_kde_formula'

class KdeL10nSv < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sv-4.10.2.tar.xz'
  sha1 'bf33ebef7934e699a52fb5735c9af73c430ebfd8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sv-4.10.2.tar.xz'
    sha1 'bf33ebef7934e699a52fb5735c9af73c430ebfd8'
  end

  depends_on 'kdelibs'
end
