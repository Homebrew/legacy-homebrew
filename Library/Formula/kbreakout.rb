require 'base_kde_formula'

class Kbreakout < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kbreakout-4.10.2.tar.xz'
  sha1 '3c93764ffcb0f1eb444b52ae7ef7c7134728178e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kbreakout-4.10.2.tar.xz'
    sha1 '3c93764ffcb0f1eb444b52ae7ef7c7134728178e'
  end

  depends_on 'kdelibs'
end
