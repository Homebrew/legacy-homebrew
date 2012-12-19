require 'base_kde_formula'

class Libkcddb < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libkcddb-4.9.4.tar.xz'
  sha1 '862239eca7ff3bd68dfcbd0cd1b95c8d99b4bf61'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libkcddb-4.9.95.tar.xz'
    sha1 '4689df4c9a053be41d089c13d038161953998513'
  end

  depends_on 'kdelibs'
end
