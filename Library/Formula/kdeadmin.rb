require 'base_kde_formula'

class Kdeadmin < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdeadmin-4.9.4.tar.xz'
  sha1 '7c5b125297ecf7e5801297fac284459209937c76'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdeadmin-4.9.95.tar.xz'
    sha1 '7a27c15f2abbf963fd6413cf097517c70ffd6530'
  end

  depends_on 'kdelibs'
end
