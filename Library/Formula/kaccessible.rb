require 'base_kde_formula'

class Kaccessible < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kaccessible-4.10.2.tar.xz'
  sha1 '453235676a1991e5f448497f8aa61d0e7ddd54f2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kaccessible-4.10.2.tar.xz'
    sha1 '453235676a1991e5f448497f8aa61d0e7ddd54f2'
  end

  depends_on 'kdelibs'
end
