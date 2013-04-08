require 'base_kde_formula'

class Korundum < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/korundum-4.10.2.tar.xz'
  sha1 '147bb8aacf8805ccde57f1d3d96e67633f317202'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/korundum-4.10.2.tar.xz'
    sha1 '147bb8aacf8805ccde57f1d3d96e67633f317202'
  end

  depends_on 'kdelibs'
end
