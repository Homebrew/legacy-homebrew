require 'base_kde_formula'

class Kjumpingcube < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kjumpingcube-4.10.2.tar.xz'
  sha1 'c81585d2e46ec0783d58e6d0068b75fd82ddd382'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kjumpingcube-4.10.2.tar.xz'
    sha1 'c81585d2e46ec0783d58e6d0068b75fd82ddd382'
  end

  depends_on 'kdelibs'
end
