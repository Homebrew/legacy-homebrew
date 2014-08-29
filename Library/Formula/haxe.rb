require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  url 'https://github.com/HaxeFoundation/haxe.git', :tag => '3.1.3'

  head 'https://github.com/HaxeFoundation/haxe.git', :branch => 'development'

  bottle do
    cellar :any
    sha1 "83fe01c0ca2997328e88ef7763181ff40cc5082a" => :mavericks
    sha1 "46c5911f3505c7e102c71dde16ed4ab2bdcc4cbc" => :mountain_lion
    sha1 "408dbaf0110cb38ee52900bd4910c56913681bab" => :lion
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
