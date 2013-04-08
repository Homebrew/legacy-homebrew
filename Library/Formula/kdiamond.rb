require 'base_kde_formula'

class Kdiamond < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdiamond-4.10.2.tar.xz'
  sha1 '57b6525cd17fa69e99d596441aa10c626766846b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdiamond-4.10.2.tar.xz'
    sha1 '57b6525cd17fa69e99d596441aa10c626766846b'
  end

  depends_on 'kdelibs'
end
