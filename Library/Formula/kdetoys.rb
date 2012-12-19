require 'base_kde_formula'

class Kdetoys < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdetoys-4.9.4.tar.xz'
  sha1 'e59638143bdf75e09ef57658f1f8a53514004a14'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdetoys-4.9.95.tar.xz'
    sha1 'da600b77ed84507f0e5de11e1d9e0b51be817c95'
  end

  depends_on 'kdelibs'
end
