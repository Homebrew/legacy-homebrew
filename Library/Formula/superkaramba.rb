require 'base_kde_formula'

class Superkaramba < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/superkaramba-4.9.4.tar.xz'
  sha1 'b42ddd333e19daf8f036b733e9dc8d4a6418bfd2'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/superkaramba-4.9.95.tar.xz'
    sha1 '7a614af0d67628515a98de206c36003c595bc977'
  end

  depends_on 'kdelibs'
end
