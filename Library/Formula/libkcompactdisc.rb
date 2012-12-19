require 'base_kde_formula'

class Libkcompactdisc < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/libkcompactdisc-4.9.4.tar.xz'
  sha1 'e1ca051ebaf3430813b9d18dd2c1dca00c147d8a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/libkcompactdisc-4.9.95.tar.xz'
    sha1 '2e7a130a7b0c2f7e2fd0ea897bf17388941407b1'
  end

  depends_on 'kdelibs'
end
