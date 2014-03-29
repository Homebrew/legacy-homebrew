require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  url 'https://github.com/HaxeFoundation/haxe.git', :tag => '3.1.2'

  head 'https://github.com/HaxeFoundation/haxe.git', :branch => 'development'

  bottle do
    cellar :any
    sha1 "f72374f99b18d65849ee654223b54e3f2b885ab5" => :mavericks
    sha1 "33ed8cc473a4ad83fec93a9ef4d45992c263aa8c" => :mountain_lion
    sha1 "4dc8205334988bfc5b0f522db410abd89ea5c13a" => :lion
  end

  depends_on 'neko'
  depends_on 'objective-caml'

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make"
    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
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
