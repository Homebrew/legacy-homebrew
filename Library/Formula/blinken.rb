require 'base_kde_formula'

class Ublinken < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/blinken-4.8.1.tar.xz'
  sha1 'ff9f07ee59145a9993604fdef7f301c09c095775'

  depends_on 'kdelibs'
end


