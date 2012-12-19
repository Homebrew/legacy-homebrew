require 'base_kde_formula'

class Kalzium < BaseKdeFormula
  homepage 'http://edu.kde.org/kalzium/'
  url 'http://download.kde.org/stable/4.9.4/src/kalzium-4.9.4.tar.xz'
  sha1 '7fb581e74cd2d561a9db7c2de754339f2e345e2a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kalzium-4.9.95.tar.xz'
    sha1 '187adc48acd35a3f71c6cc48cfb53d1a115a60e1'
  end

  depends_on 'kdelibs'
end
