require 'base_kde_formula'

class Kscd < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kscd-4.10.2.tar.xz'
  sha1 '10b7d920fc70b4001e6f7d20e643eb2b09a42dfa'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kscd-4.10.2.tar.xz'
    sha1 '10b7d920fc70b4001e6f7d20e643eb2b09a42dfa'
  end

  depends_on 'kdelibs'
end
