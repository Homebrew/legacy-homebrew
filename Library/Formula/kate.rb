require 'base_kde_formula'

class Kate < BaseKdeFormula
  homepage 'http://kate-editor.org'
  url 'http://download.kde.org/stable/4.9.4/src/kate-4.9.4.tar.xz'
  sha1 '7740527d43f057c949c4954d916cd7237c915b20'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kate-4.9.95.tar.xz'
    sha1 'ba1a90474b3f7239cf264537c8b35cac8a64d3b4'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
