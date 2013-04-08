require 'base_kde_formula'

class Kolf < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kolf-4.10.2.tar.xz'
  sha1 '148fe1a39763b97daaa3e4257b1f0e80e34cc723'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kolf-4.10.2.tar.xz'
    sha1 '148fe1a39763b97daaa3e4257b1f0e80e34cc723'
  end

  depends_on 'kdelibs'
end
