require 'base_kde_formula'

class Libkdeedu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libkdeedu-4.9.4.tar.xz'
  sha1 'ecaf85ede42bb99850af6b1a35912327d95a1322'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libkdeedu-4.9.95.tar.xz'
    sha1 '1e7fe03209ed0e1c7ba528c93ee25b5144b6428b'
  end

  depends_on 'kdelibs'
end
