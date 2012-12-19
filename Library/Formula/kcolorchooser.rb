require 'base_kde_formula'

class Kcolorchooser < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kcolorchooser-4.9.4.tar.xz'
  sha1 'c8c41d4724e689cf70028bafb3bb705fe90607ea'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kcolorchooser-4.9.95.tar.xz'
    sha1 'd462db8957d92f642d635312858d137f65285e6f'
  end

  depends_on 'kdelibs'
end
