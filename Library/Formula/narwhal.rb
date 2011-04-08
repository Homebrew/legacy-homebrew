require 'formula'

class Narwhal < Formula
  url 'https://github.com/280north/narwhal/tarball/v0.3.2'
  md5 'c5f8c0af38b79a7a7b827d3f05f79e21'
  homepage 'http://www.narwhaljs.org/'

  head 'git://github.com/280north/narwhal.git'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |d| ln_s d, bin }
  end
end
