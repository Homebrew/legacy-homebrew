require 'base_kde_formula'

class Ksaneplugin < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/ksaneplugin-4.10.2.tar.xz'
  sha1 '076c7ed01024c91bc690fe07e495e37444dbcdd5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/ksaneplugin-4.10.2.tar.xz'
    sha1 '076c7ed01024c91bc690fe07e495e37444dbcdd5'
  end

  depends_on 'kdelibs'
end
