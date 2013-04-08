require 'base_kde_formula'

class Kubrick < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kubrick-4.10.2.tar.xz'
  sha1 'a112aa326c024e7bf224ecdcfe79122e9605d988'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kubrick-4.10.2.tar.xz'
    sha1 'a112aa326c024e7bf224ecdcfe79122e9605d988'
  end

  depends_on 'kdelibs'
end
