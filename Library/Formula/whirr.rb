require 'formula'

class Whirr < Formula
  homepage 'http://whirr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=whirr/whirr-0.7.1/whirr-0.7.1.tar.gz'
  sha1 '15772fd7bf35cbc1c50023f4a22bcbb1cd1f80c9'

  def install
    lib.install Dir['lib/*']
    bin.install Dir['bin/whirr']
  end
end
