require 'base_kde_formula'

class Klettres < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/klettres-4.9.4.tar.xz'
  sha1 'f71f6b3196f9836869d7ee937e75c0492c28c9c5'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/klettres-4.9.95.tar.xz'
    sha1 '528585e2a42de8043a143aa23c10be070160cb65'
  end

  depends_on 'kdelibs'
end
