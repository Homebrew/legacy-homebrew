require 'base_kde_formula'

class Kdewebdev < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdewebdev-4.9.4.tar.xz'
  sha1 'f81a44220c5622b222cb032160be06bf1d965704'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdewebdev-4.9.95.tar.xz'
    sha1 '104f936fbaf9c882343db61acfcde26d762db954'
  end

  depends_on 'kdelibs'
end
