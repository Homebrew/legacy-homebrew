require 'base_kde_formula'

class Korundum < BaseKdeFormula
  homepage 'http://kde.org'
  url 'http://download.kde.org/stable/4.8.1/src/korundum-4.8.1.tar.xz'
  sha1 '10788c362d209785ce800d70c3b8823af49cf16c'
  depends_on 'kdelibs'
end
