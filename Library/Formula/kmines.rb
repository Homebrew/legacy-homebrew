require 'base_kde_formula'

class Kmines < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kmines-4.10.2.tar.xz'
  sha1 '5b0775fb30fe59c017651d80658cc59f1358b7a4'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kmines-4.10.2.tar.xz'
    sha1 '5b0775fb30fe59c017651d80658cc59f1358b7a4'
  end

  depends_on 'kdelibs'
end
