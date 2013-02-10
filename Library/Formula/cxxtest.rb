require 'formula'

class Cxxtest < Formula
  homepage 'http://cxxtest.com'
  url 'https://github.com/CxxTest/cxxtest/archive/4.1.tar.gz'
  sha1 '8d6053bbbf0359f42d306e9d69965243c23e1b34'

  head 'https://github.com/CxxTest/cxxtest.git', :branch => 'master'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/cxxtestgen"
    include.install_symlink "#{libexec}/cxxtest"
  end
end
