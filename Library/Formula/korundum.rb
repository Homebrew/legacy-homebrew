require 'base_kde_formula'

class Korundum < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/korundum-4.9.4.tar.xz'
  sha1 '13fdd219fe1d1082d89d965026adc2e58906da34'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/korundum-4.9.95.tar.xz'
    sha1 '780275964370eef3c14ce88eeb6389335a6379b2'
  end

  depends_on 'kdelibs'
end
