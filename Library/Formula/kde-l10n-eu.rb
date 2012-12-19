require 'base_kde_formula'

class Kde-l10n-eu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-eu-4.9.4.tar.xz'
  sha1 '42e31387946c042397676b548cfbe0badcfbf789'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-eu-4.9.95.tar.xz'
    sha1 '3dd402a4b1f93a16986b2e372cc4957a2e168b4d'
  end

  depends_on 'kdelibs'
end
