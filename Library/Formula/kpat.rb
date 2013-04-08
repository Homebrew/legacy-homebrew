require 'base_kde_formula'

class Kpat < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kpat-4.10.2.tar.xz'
  sha1 '9a4309cbadd8214cb2dd8ab1cd8bae4c20194cff'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kpat-4.10.2.tar.xz'
    sha1 '9a4309cbadd8214cb2dd8ab1cd8bae4c20194cff'
  end

  depends_on 'kdelibs'
end
