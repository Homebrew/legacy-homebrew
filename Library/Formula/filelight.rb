require 'base_kde_formula'

class Filelight < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/filelight-4.9.4.tar.xz'
  sha1 '8fddb94d96df5a3cf83775f81204d716040086bf'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/filelight-4.9.95.tar.xz'
    sha1 '9c559eacc9658a4aa227d2bdf28504019cac5e8f'
  end

  depends_on 'kdelibs'
end
