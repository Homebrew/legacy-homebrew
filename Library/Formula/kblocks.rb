require 'base_kde_formula'

class Kblocks < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kblocks-4.10.2.tar.xz'
  sha1 'be903b314547ccdc0eee335a34bac00bc769c3b7'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kblocks-4.10.2.tar.xz'
    sha1 'be903b314547ccdc0eee335a34bac00bc769c3b7'
  end

  depends_on 'kdelibs'
end
