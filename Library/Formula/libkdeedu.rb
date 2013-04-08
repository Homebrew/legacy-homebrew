require 'base_kde_formula'

class Libkdeedu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/libkdeedu-4.10.2.tar.xz'
  sha1 '2c0f6ebfc1e51919da0313b0a93d149dfd1d0be7'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/libkdeedu-4.10.2.tar.xz'
    sha1 '2c0f6ebfc1e51919da0313b0a93d149dfd1d0be7'
  end

  depends_on 'kdelibs'
end
