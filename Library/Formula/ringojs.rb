require 'formula'

class Ringojs < Formula
  homepage 'http://ringojs.org'
  url 'http://ringojs.org/downloads/ringojs-0.9.tar.gz'
  sha1 '1b0b7efcad323d5dd7ce3b1dbdfc079914e8713a'

  skip_clean 'libexec/packages'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
