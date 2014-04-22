require 'formula'

class Metalua < Formula
  homepage 'http://metalua.luaforge.net/'
  url 'https://github.com/fab13n/metalua/archive/0.5-rc2.tar.gz'
  version '0.5-rc2'
  sha1 'ee28c801e9673cc11d1cecd0a9fda87e7d21fd6d'

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

  test do
    output = `#{bin}/metalua -e "for i=0,9 do io.write(i) end"`
    assert_equal "0123456789", output
    assert_equal 0, $?.exitstatus
  end
end
