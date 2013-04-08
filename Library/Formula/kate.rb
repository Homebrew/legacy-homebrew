require 'base_kde_formula'

class Kate < BaseKdeFormula
  homepage 'http://kate-editor.org'
  url 'http://download.kde.org/stable/4.10.2/src/kate-4.10.2.tar.xz'
  sha1 '117850ca1728c309310f23a5ac2d583cfdfd29c7'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kate-4.10.2.tar.xz'
    sha1 '117850ca1728c309310f23a5ac2d583cfdfd29c7'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
