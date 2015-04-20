require 'formula'

class Ringojs < Formula
  homepage 'http://ringojs.org'
  url 'https://github.com/ringo/ringojs/releases/download/v0.11.0/ringojs-0.11.tar.gz'
  sha1 'ffeca5905165b0c883fb81cfcad8ca640772bf03'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
