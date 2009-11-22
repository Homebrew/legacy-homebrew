require 'formula'

class Leiningen <Formula
  version '0.5.0'
  url 'http://github.com/technomancy/leiningen/tarball/0.5.0'
  homepage 'http://github.com/technomancy/leiningen'
  md5 '9f63981bbcf11272270bdff0747fff2f'

  def install
    system "bin/lein self-install"
    prefix.install  %w[bin README.md]
  end
end
