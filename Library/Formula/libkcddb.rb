require 'base_kde_formula'

class Libkcddb < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkcddb-4.10.2.tar.xz'
  sha1 'c9e8d93ecf9f238bf12d98d27fc20421af5ae240'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkcddb-4.10.2.tar.xz'
    sha1 'c9e8d93ecf9f238bf12d98d27fc20421af5ae240'
  end

  depends_on 'kdelibs'
end
