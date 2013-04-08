require 'base_kde_formula'

class Kdesdk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdesdk-4.10.2.tar.xz'
  sha1 '0cedb222c469f7e465486ac744806e52f762b413'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdesdk-4.10.2.tar.xz'
    sha1 '0cedb222c469f7e465486ac744806e52f762b413'
  end

  depends_on 'kdelibs'
end
