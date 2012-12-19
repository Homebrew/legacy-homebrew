require 'base_kde_formula'

class Kcalc < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kcalc-4.9.4.tar.xz'
  sha1 '2cdffc6aad88d8da2e4f37b2d92c40a64a77b9dc'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kcalc-4.9.95.tar.xz'
    sha1 '1fe95e99e32b5fdd9280849c2fde5389c1650678'
  end

  depends_on 'kdelibs'
end
