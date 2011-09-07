require 'formula'

class Metalua < Formula
  head 'https://github.com/fab13n/metalua.git'
  url 'https://github.com/fab13n/metalua/tarball/0.5-rc2'
  homepage 'http://metalua.luaforge.net/'
  md5 'c841976b3a2fe9b7322aaca16927c9e2'
  version '0.5-rc2'

  depends_on 'lua'

  def install
    Dir.chdir "src"
    ENV["INSTALL_BIN"] = bin
    ENV["INSTALL_LIB"] = lib

    system "./make.sh"
    system "./make-install.sh"
  end
end
