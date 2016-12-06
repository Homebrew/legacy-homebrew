require 'formula'

class Perlbrew < Formula
  head 'https://github.com/gugod/App-perlbrew.git', :using => :git
  homepage 'http://search.cpan.org/~gugod/App-perlbrew/'

  depends_on 'perl'

  def install
      system("mkdir #{prefix}/bin")
      system("install perlbrew #{prefix}/bin/perlbrew")
  end
end
