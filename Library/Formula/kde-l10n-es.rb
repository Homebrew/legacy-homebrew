require 'base_kde_formula'

class Kde-l10n-es < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-es-4.9.4.tar.xz'
  sha1 '5df9817ab57474b40daa6f05869ab77ff0bdb36b'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-es-4.9.95.tar.xz'
    sha1 'a0425c3d35c899a4f1cb21a06550ea68af5a47bd'
  end

  depends_on 'kdelibs'
end
