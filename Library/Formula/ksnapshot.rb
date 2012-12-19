require 'base_kde_formula'

class Ksnapshot < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/ksnapshot-4.9.4.tar.xz'
  sha1 '0c38aaf8e536704a44b469d708e523f0247a8086'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/ksnapshot-4.9.95.tar.xz'
    sha1 '6f8daa20f1ac77f1cb5b6737dc83c26073cf316b'
  end

  depends_on 'kdelibs'
end
