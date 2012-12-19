require 'base_kde_formula'

class Khangman < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/khangman-4.9.4.tar.xz'
  sha1 'a736204fd77a9652acf247681d0dc560afc45ddb'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/khangman-4.9.95.tar.xz'
    sha1 '84fe69921859cd51672563d47fd3fdf6cf473b99'
  end

  depends_on 'kdelibs'
end
