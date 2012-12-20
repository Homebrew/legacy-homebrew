require 'base_kde_formula'

class KdeL10nSi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-si-4.9.4.tar.xz'
  sha1 '555b535790739f7ec2aec140332a406cbf0bbed9'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-si-4.9.95.tar.xz'
    sha1 '0653a559047d3b4882ffc4251d3e188d58824867'
  end

  depends_on 'kdelibs'
end
