require 'base_kde_formula'

class Pykde4 < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/pykde4-4.9.4.tar.xz'
  sha1 'd9c5fbbc79e95fca0ab2523a8de4e2291641bea3'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/pykde4-4.9.95.tar.xz'
    sha1 'b141ca1ba9082363bdc660ea441ec4948437218e'
  end

  depends_on 'kdelibs'
end
