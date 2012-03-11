require 'base_kde_formula'

class Ufilelight < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/filelight-4.8.1.tar.xz'
  sha1 '24cd19b927221de2dafd2a1c3d5e8a72a41ec4b5'

  depends_on 'kdelibs'
end


