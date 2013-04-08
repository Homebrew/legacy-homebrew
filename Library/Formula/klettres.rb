require 'base_kde_formula'

class Klettres < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/klettres-4.10.2.tar.xz'
  sha1 '101cd33b6e099174358d1ac754747cdf17cf6ba5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/klettres-4.10.2.tar.xz'
    sha1 '101cd33b6e099174358d1ac754747cdf17cf6ba5'
  end

  depends_on 'kdelibs'
end
