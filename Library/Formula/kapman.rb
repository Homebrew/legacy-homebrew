require 'base_kde_formula'

class Kapman < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kapman-4.10.2.tar.xz'
  sha1 'b2a8122fbebc364dee64707ccc720e62eb1af66a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kapman-4.10.2.tar.xz'
    sha1 'b2a8122fbebc364dee64707ccc720e62eb1af66a'
  end

  depends_on 'kdelibs'
end
