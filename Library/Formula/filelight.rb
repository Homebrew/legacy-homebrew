require 'base_kde_formula'

class Filelight < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/filelight-4.10.2.tar.xz'
  sha1 '1047e985fead8655b9eac888315b007844b34a68'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/filelight-4.10.2.tar.xz'
    sha1 '1047e985fead8655b9eac888315b007844b34a68'
  end

  depends_on 'kdelibs'
end
