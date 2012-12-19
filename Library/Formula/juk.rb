require 'base_kde_formula'

class Juk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/juk-4.9.4.tar.xz'
  sha1 '4ce2a0ce7b5c128c63d1fefcdbd3d2c7c8cf6e56'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/juk-4.9.95.tar.xz'
    sha1 'caf567e0bb35955fb490875f3f6284a94805b5d7'
  end

  depends_on 'kdelibs'
end
