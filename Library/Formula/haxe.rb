require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  url 'https://github.com/HaxeFoundation/haxe.git', :tag => 'v3.1.1'

  head 'https://github.com/HaxeFoundation/haxe.git', :branch => 'development'

  bottle do
    cellar :any
    sha1 "2d0d03f2a3a1da2bf89473ce495d68d71922d380" => :mavericks
    sha1 "39f8993c08e35b06a9b57f6ea997c57029898a76" => :mountain_lion
    sha1 "4fd905adeeab662f5bb547053dce580dcd0936f3" => :lion
  end

  depends_on 'neko'
  depends_on 'objective-caml'

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make"
    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
  end

  def caveats; <<-EOS.undent
    Add the following line to your .bashrc or equivalent:
      export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end
end
