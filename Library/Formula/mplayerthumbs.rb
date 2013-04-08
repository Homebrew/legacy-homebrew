require 'base_kde_formula'

class Mplayerthumbs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/mplayerthumbs-4.10.2.tar.xz'
  sha1 '80f35eb2e30382984cb3529c4226f911f5e2c30a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/mplayerthumbs-4.10.2.tar.xz'
    sha1 '80f35eb2e30382984cb3529c4226f911f5e2c30a'
  end

  depends_on 'kdelibs'
end
