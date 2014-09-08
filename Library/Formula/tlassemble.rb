require 'formula'

class Tlassemble < Formula
  homepage 'http://www.dayofthenewdan.com/projects/tlassemble/'
  url 'https://github.com/dbridges/cocoa-tlassemble/archive/v1.0.tar.gz'
  sha1 'a261e39acc38996ebe24df2c37f935d9db1033ca'

  def install
    system 'make'
    bin.install 'tlassemble'
  end

  test do
    system "\"#{bin}/tlassemble\" --help | grep 'tlassemble 1.0'"
  end
end
