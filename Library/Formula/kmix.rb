require 'base_kde_formula'

class Kmix < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kmix-4.9.4.tar.xz'
  sha1 '812087a8acfdbe676af422f2742f8c4fee91a835'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kmix-4.9.95.tar.xz'
    sha1 'f58cd0308933b02aae1ceff497fdb3ae08b7e952'
  end

  depends_on 'kdelibs'
end
