require 'base_kde_formula'

class Kdegraphics-thumbnailers < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdegraphics-thumbnailers-4.9.4.tar.xz'
  sha1 'ea6156de54839157f933588eb7db6d94a2399f3b'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdegraphics-thumbnailers-4.9.95.tar.xz'
    sha1 '5d6374dcbc5991687367f678f53e289bbb434bd8'
  end

  depends_on 'kdelibs'
end
