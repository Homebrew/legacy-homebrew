require 'base_kde_formula'

class Kde-l10n-hr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-hr-4.9.4.tar.xz'
  sha1 '1aad6f6fddd013f4e7f866cc785bf91fdcdd99a5'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-hr-4.9.95.tar.xz'
    sha1 'c95d43559912fc512dd0792294c7ba628c447992'
  end

  depends_on 'kdelibs'
end
