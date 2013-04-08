require 'base_kde_formula'

class Kblackbox < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kblackbox-4.10.2.tar.xz'
  sha1 '3d29652827a4fba86615a424f5a5b0bcffc184b7'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kblackbox-4.10.2.tar.xz'
    sha1 '3d29652827a4fba86615a424f5a5b0bcffc184b7'
  end

  depends_on 'kdelibs'
end
