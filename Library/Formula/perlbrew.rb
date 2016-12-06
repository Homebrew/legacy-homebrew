require 'formula'

class Perlbrew < Formula
  head 'https://github.com/gugod/App-perlbrew.git', :using => :git
  homepage 'http://search.cpan.org/~gugod/App-perlbrew/'

  depends_on 'perl'

  def install
      bin.install "perlbrew"
  end
end
