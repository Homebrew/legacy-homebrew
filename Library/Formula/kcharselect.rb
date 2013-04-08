require 'base_kde_formula'

class Kcharselect < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kcharselect-4.10.2.tar.xz'
  sha1 '2e5b06c4be689097f3999ff772bc12373fa81e7c'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kcharselect-4.10.2.tar.xz'
    sha1 '2e5b06c4be689097f3999ff772bc12373fa81e7c'
  end

  depends_on 'kdelibs'
end
