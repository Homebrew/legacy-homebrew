require 'base_kde_formula'

class Kfourinline < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kfourinline-4.10.2.tar.xz'
  sha1 'b587f56bf5f095ec44da271e04b325f6dcc5c5f0'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kfourinline-4.10.2.tar.xz'
    sha1 'b587f56bf5f095ec44da271e04b325f6dcc5c5f0'
  end

  depends_on 'kdelibs'
end
