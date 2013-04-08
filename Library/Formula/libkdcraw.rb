require 'base_kde_formula'

class Libkdcraw < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkdcraw-4.10.2.tar.xz'
  sha1 '639bf3bf9a872cccbb39e5d16188dfa1d895463a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkdcraw-4.10.2.tar.xz'
    sha1 '639bf3bf9a872cccbb39e5d16188dfa1d895463a'
  end

  depends_on 'kdelibs'
end
