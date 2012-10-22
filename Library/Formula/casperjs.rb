require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/zipball/1.0.0-RC2'
  sha1 'b3c336a98a3d3b5e3640ec6c44d93bdbf0974f89'
  version '1.0.0-RC2'

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end
