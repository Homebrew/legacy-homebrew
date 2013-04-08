require 'base_kde_formula'

class Smokekde < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/smokekde-4.10.2.tar.xz'
  sha1 '8f99c5a53634532f6d8d02dc5f7ec0ffba194f4a'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/smokekde-4.10.2.tar.xz'
    sha1 '8f99c5a53634532f6d8d02dc5f7ec0ffba194f4a'
  end

  depends_on 'kdelibs'
end
