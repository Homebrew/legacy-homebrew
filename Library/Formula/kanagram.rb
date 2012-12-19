require 'base_kde_formula'

class Kanagram < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kanagram-4.9.4.tar.xz'
  sha1 'ef8c012ce41094b7074502753153398028e58c99'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kanagram-4.9.95.tar.xz'
    sha1 '6491b2dc8e2473b140cc6ae20b1797f9d95e71a3'
  end

  depends_on 'kdelibs'
end
