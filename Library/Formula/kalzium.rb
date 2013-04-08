require 'base_kde_formula'

class Kalzium < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kalzium-4.10.2.tar.xz'
  sha1 'bf4c5b19905d83dede215b672d6b2911eb6d57cc'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kalzium-4.10.2.tar.xz'
    sha1 'bf4c5b19905d83dede215b672d6b2911eb6d57cc'
  end

  depends_on 'kdelibs'
end
