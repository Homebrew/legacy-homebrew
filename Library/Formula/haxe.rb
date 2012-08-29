require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org/'
  url 'http://haxe.org/file/haxe-2.09-osx.tar.gz'
  sha1 '64c538b85578ac9adf44b5727a195ca999301c93'

  def install
    bin.install %w(haxe haxedoc haxelib)
    (share+"haxe").install "std"
  end

  def caveats; <<-EOS.undent
    HaXe needs to know how to find its standard library so add this to your
    shell profile:
      export HAXE_LIBRARY_PATH="$(brew --prefix)/share/haxe/std"
    EOS
  end
end
