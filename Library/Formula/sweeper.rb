require 'base_kde_formula'

class Sweeper < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/sweeper-4.10.2.tar.xz'
  sha1 'b817768cbf7c47ba8d0f61c714849e9074cebc43'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/sweeper-4.10.2.tar.xz'
    sha1 'b817768cbf7c47ba8d0f61c714849e9074cebc43'
  end

  depends_on 'kdelibs'
end
