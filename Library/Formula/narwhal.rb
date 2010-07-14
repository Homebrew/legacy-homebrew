require 'formula'

class Narwhal <Formula
  head 'git://github.com/tlrobinson/narwhal.git'
  homepage 'http://www.narwhaljs.org/'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |d| ln_s d, bin }
  end
end
