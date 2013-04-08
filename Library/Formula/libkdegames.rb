require 'base_kde_formula'

class Libkdegames < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkdegames-4.10.2.tar.xz'
  sha1 '3a08bf0f98c00a02363da1a61beea61ad1e01b5b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkdegames-4.10.2.tar.xz'
    sha1 '3a08bf0f98c00a02363da1a61beea61ad1e01b5b'
  end

  depends_on 'kdelibs'
end
