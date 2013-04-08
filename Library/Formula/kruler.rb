require 'base_kde_formula'

class Kruler < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kruler-4.10.2.tar.xz'
  sha1 '9424591fe16cd1930f0a6bf89fcf7b56c0560227'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kruler-4.10.2.tar.xz'
    sha1 '9424591fe16cd1930f0a6bf89fcf7b56c0560227'
  end

  depends_on 'kdelibs'
end
