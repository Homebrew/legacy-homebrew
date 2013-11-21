require 'formula'

class Whirr < Formula
  homepage 'http://whirr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=whirr/whirr-0.8.2/whirr-0.8.2.tar.gz'
  sha1 'd5bd127bc396795e4c512c1584a8c73abde5a78c'

  def install
    libexec.install %w[bin conf lib]
    bin.write_exec_script libexec/'bin/whirr'
  end
end
