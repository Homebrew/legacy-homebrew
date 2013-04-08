require 'base_kde_formula'

class Bomber < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/bomber-4.10.2.tar.xz'
  sha1 '7f5e955127da33c7589103628cac356e6ebe4141'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/bomber-4.10.2.tar.xz'
    sha1 '7f5e955127da33c7589103628cac356e6ebe4141'
  end

  depends_on 'kdelibs'
end
