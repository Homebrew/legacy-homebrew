require 'base_kde_formula'

class Knetwalk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/knetwalk-4.10.2.tar.xz'
  sha1 '6b5a992d5a6ca4ddb41561bdf9d2b83be0091962'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/knetwalk-4.10.2.tar.xz'
    sha1 '6b5a992d5a6ca4ddb41561bdf9d2b83be0091962'
  end

  depends_on 'kdelibs'
end
