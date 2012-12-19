require 'base_kde_formula'

class Perlqt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/perlqt-4.9.4.tar.xz'
  sha1 'daa1ceadd1008cc7a82eb810731ff7c76fccb674'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/perlqt-4.9.95.tar.xz'
    sha1 'bd70ee9d7c5dc2e69560f8e1a324a7d4fd70d1a9'
  end

  depends_on 'kdelibs'
end
