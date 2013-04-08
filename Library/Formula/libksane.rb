require 'base_kde_formula'

class Libksane < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libksane-4.10.2.tar.xz'
  sha1 '3b9b83974dd2cdabe0cbe5fd3904ced1413a756b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libksane-4.10.2.tar.xz'
    sha1 '3b9b83974dd2cdabe0cbe5fd3904ced1413a756b'
  end

  depends_on 'kdelibs'
end
