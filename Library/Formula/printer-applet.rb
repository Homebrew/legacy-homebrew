require 'base_kde_formula'

class Uprinter-applet < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/printer-applet-4.8.1.tar.xz'
  sha1 'c3002fea0382386256c3acaebd907a41db0ccc4e'

  depends_on 'kdelibs'
end


