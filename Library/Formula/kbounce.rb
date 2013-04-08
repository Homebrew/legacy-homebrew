require 'base_kde_formula'

class Kbounce < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kbounce-4.10.2.tar.xz'
  sha1 '1f27198383237538791eccad15c7ca6da946826e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kbounce-4.10.2.tar.xz'
    sha1 '1f27198383237538791eccad15c7ca6da946826e'
  end

  depends_on 'kdelibs'
end
