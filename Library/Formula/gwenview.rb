require 'base_kde_formula'

class Gwenview < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/gwenview-4.9.4.tar.xz'
  sha1 '2bff681c1553f8431dcab24c809cde2586e69b88'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/gwenview-4.9.95.tar.xz'
    sha1 'a1002eed0b99623c157a810a9095b105fc1c0e27'
  end

  depends_on 'kdelibs'
end
