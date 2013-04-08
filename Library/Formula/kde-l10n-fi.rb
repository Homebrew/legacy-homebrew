require 'base_kde_formula'

class KdeL10nFi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-fi-4.10.2.tar.xz'
  sha1 '88d2a21a2ee7f93293cb2f04ef0fd0bfc494ee2c'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-fi-4.10.2.tar.xz'
    sha1 '88d2a21a2ee7f93293cb2f04ef0fd0bfc494ee2c'
  end

  depends_on 'kdelibs'
end
