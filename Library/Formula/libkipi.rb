require 'base_kde_formula'

class Libkipi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libkipi-4.9.4.tar.xz'
  sha1 'fe3c09ed2bc378d975b1d2f495752f03529e52e7'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libkipi-4.9.95.tar.xz'
    sha1 '100b849be3f0db533b3b213256714b065b478872'
  end

  depends_on 'kdelibs'
end
