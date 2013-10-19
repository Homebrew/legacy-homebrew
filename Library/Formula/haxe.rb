require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  url 'https://github.com/HaxeFoundation/haxe.git', :tag => 'v3.0.1'

  head 'https://github.com/HaxeFoundation/haxe.git'

  depends_on 'neko'
  depends_on 'objective-caml'

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system 'make'
    bin.install 'haxe'
    bin.install 'std/tools/haxelib/haxelib.sh' => 'haxelib'
    (lib/'haxe').install 'std'
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
