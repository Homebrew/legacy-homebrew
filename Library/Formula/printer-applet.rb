require 'base_kde_formula'

class PrinterApplet < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/printer-applet-4.9.4.tar.xz'
  sha1 '3a375dd86a44ae1f720a3cc10ae91a43581a68dc'

  depends_on 'kdelibs'
end
