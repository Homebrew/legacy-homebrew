require 'base_kde_formula'

class Kmouth < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kmouth-4.9.4.tar.xz'
  sha1 '5f7691f0306dd1690fbbf05d15c6c1636ecd80a9'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kmouth-4.9.95.tar.xz'
    sha1 '62eb1c7db5170f967069f7e3a97b4a94b8e4fc1f'
  end

  depends_on 'kdelibs'
end
