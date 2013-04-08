require 'base_kde_formula'

class Knavalbattle < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/knavalbattle-4.10.2.tar.xz'
  sha1 '668a3b98bd5d64ff1d35dc1f46ec2f4a5aa188fe'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/knavalbattle-4.10.2.tar.xz'
    sha1 '668a3b98bd5d64ff1d35dc1f46ec2f4a5aa188fe'
  end

  depends_on 'kdelibs'
end
