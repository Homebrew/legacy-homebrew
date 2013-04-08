require 'base_kde_formula'

class Gwenview < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/gwenview-4.10.2.tar.xz'
  sha1 '6872a50b2fda3bed717e0fc1b367b02ad80550dd'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/gwenview-4.10.2.tar.xz'
    sha1 '6872a50b2fda3bed717e0fc1b367b02ad80550dd'
  end

  depends_on 'kdelibs'
end
