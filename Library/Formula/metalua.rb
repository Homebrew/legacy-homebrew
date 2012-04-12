require 'formula'

class Metalua < Formula
  homepage 'http://metalua.luaforge.net/'
  url 'https://github.com/fab13n/metalua/tarball/0.5-rc2'
  version '0.5-rc2'
  md5 'c841976b3a2fe9b7322aaca16927c9e2'

  head 'https://github.com/fab13n/metalua.git'

  depends_on 'lua'

  def install
    cd "src" do
      ENV["INSTALL_BIN"] = bin
      ENV["INSTALL_LIB"] = lib

      system "./make.sh"
      system "./make-install.sh"
    end
  end
end
