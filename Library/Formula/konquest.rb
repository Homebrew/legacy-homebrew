require 'base_kde_formula'

class Konquest < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/konquest-4.10.2.tar.xz'
  sha1 'acb21acfab00f8a5a03105fad6100cec513958ff'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/konquest-4.10.2.tar.xz'
    sha1 'acb21acfab00f8a5a03105fad6100cec513958ff'
  end

  depends_on 'kdelibs'
end
