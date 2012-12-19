
require 'base_kde_formula'

class Ark < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/ark-4.9.4.tar.xz'
  sha1 '074aece141ec229b5d72b39e4d31af4e5b4550cb'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/ark-4.9.95.tar.xz'
    sha1 'cf7e2248e9f5fb94701017f4fdf6c92b647cc0f3'
  end
  depends_on 'kdelibs'
end
