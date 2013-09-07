require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  # v3-00 was tagged before project moved to git, so doesn't include submodules
  url 'https://github.com/HaxeFoundation/haxe.git', :revision => '40451b41b09b9155682dad2f2f9db020c1f23678'
  version '3.0.0-40451b4'

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
