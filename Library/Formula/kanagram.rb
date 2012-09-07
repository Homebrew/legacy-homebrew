require 'base_kde_formula'

class Ukanagram < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kanagram-4.8.1.tar.xz'
  sha1 'd41fa85f894fb0ada8757e4282a57102fda32006'

  depends_on 'kdelibs'
end


