require 'formula'

class Whirr < Formula
  homepage 'http://whirr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=whirr/whirr-0.8.1/whirr-0.8.1.tar.gz'
  sha1 '536bf3ea97c85442964eaabd6314b869b37b422e'

  def install
    libexec.install %w[bin conf lib]
    bin.write_exec_script libexec/'bin/whirr'
  end
end
