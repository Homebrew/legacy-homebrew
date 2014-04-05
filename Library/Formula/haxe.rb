require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  url 'https://github.com/HaxeFoundation/haxe.git', :tag => '3.1.2'

  head 'https://github.com/HaxeFoundation/haxe.git', :branch => 'development'

  bottle do
    cellar :any
    sha1 "b26c27ea86f207d838d039e7d18e6c61fdcc3354" => :mavericks
    sha1 "203ad40ae2ca4b6d7747c4e69f316a99ae045e09" => :mountain_lion
    sha1 "b8a047a98ed5d2f5cc8aedfd468a7ecbe027ca4e" => :lion
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
