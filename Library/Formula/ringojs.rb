require 'formula'

class Ringojs < Formula
  homepage 'http://ringojs.org'
  url 'http://ringojs.org/downloads/ringojs-0.10.tar.gz'
  sha1 'e8ca13e23ab757f1e52132a1357a59b107318e91'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
