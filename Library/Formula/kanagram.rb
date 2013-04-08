require 'base_kde_formula'

class Kanagram < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kanagram-4.10.2.tar.xz'
  sha1 '2536db114e6be17baf1556293c95b70fe83aa609'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kanagram-4.10.2.tar.xz'
    sha1 '2536db114e6be17baf1556293c95b70fe83aa609'
  end

  depends_on 'kdelibs'
end
