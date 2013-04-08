require 'base_kde_formula'

class Kactivities < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kactivities-4.10.2.tar.xz'
  sha1 'bde79ed3db93d5fa72e1081a6638c5cb777f495e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kactivities-4.10.2.tar.xz'
    sha1 'bde79ed3db93d5fa72e1081a6638c5cb777f495e'
  end

  depends_on 'kdelibs'
end
