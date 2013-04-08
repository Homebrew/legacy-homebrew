require 'base_kde_formula'

class Palapeli < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/palapeli-4.10.2.tar.xz'
  sha1 'df69d8a792aa1283c4842b2e26d24c37c284380a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/palapeli-4.10.2.tar.xz'
    sha1 'df69d8a792aa1283c4842b2e26d24c37c284380a'
  end

  depends_on 'kdelibs'
end
