require 'formula'

class Ant < Formula
  homepage 'http://ant.apache.org/'
  url 'http://apache.mirrors.timporter.net//ant/binaries/apache-ant-1.9.0-bin.zip'
  sha1 'd9823e0e1ba75f3600f7d06b31308b2454a9c2bd'

  def install
    libexec.install %w{bin lib}
    bin.install_symlink libexec+'bin/ant'
  end

end
