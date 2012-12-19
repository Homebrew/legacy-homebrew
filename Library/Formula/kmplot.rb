require 'base_kde_formula'

class Kmplot < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kmplot-4.9.4.tar.xz'
  sha1 '07e94f3d66bae5bf518117d76d15f6d996174b5e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kmplot-4.9.95.tar.xz'
    sha1 'd29c5464d7177092f2cfc44acc1b5654d3a708f0'
  end

  depends_on 'kdelibs'
end
