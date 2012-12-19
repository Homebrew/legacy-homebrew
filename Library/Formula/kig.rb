require 'base_kde_formula'

class Kig < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kig-4.9.4.tar.xz'
  sha1 'b116a1ad9877e382430511c9f28e61b42a927b82'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kig-4.9.95.tar.xz'
    sha1 '414b9d1dba8c25685ffcd6867bfe6a0b0c8066a4'
  end

  depends_on 'kdelibs'
end
