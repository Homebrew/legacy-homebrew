require 'base_kde_formula'

class Kdesdk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdesdk-4.9.4.tar.xz'
  sha1 '1742284169b2c9e0d9459241f3277a137a282846'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdesdk-4.9.95.tar.xz'
    sha1 'e73f4e7d2b02855230b289994da56fd6eabc7e38'
  end

  depends_on 'kdelibs'
end
