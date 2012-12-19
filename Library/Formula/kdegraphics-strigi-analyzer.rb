require 'base_kde_formula'

class Kdegraphics-strigi-analyzer < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdegraphics-strigi-analyzer-4.9.4.tar.xz'
  sha1 'cca29298ab63c7e775c81a2266c431507490c93a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdegraphics-strigi-analyzer-4.9.95.tar.xz'
    sha1 'd5ea9736fd1aa282b3437b3baa28c0956723716c'
  end

  depends_on 'kdelibs'
end
