require 'base_kde_formula'

class Kmousetool < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kmousetool-4.9.4.tar.xz'
  sha1 '22b82033de4739d82e3e82dcd345cb66eaa6d9fb'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kmousetool-4.9.95.tar.xz'
    sha1 'a2d8f996ed8802875724fff9364f94a727cd8329'
  end

  depends_on 'kdelibs'
end
