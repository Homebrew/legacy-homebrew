require 'base_kde_formula'

class Ksaneplugin < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/ksaneplugin-4.9.4.tar.xz'
  sha1 'e4d06db72f4b1d7268bdc31f760dea3e91a6c920'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/ksaneplugin-4.9.95.tar.xz'
    sha1 'b29c987dd00c41ab70a3bae97d6127a669308311'
  end

  depends_on 'kdelibs'
end
