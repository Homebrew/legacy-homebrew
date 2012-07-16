require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org/'
  url 'http://haxe.org/file/haxe-2.10-osx.tar.gz'
  sha1 '2e173eb206443c1af739d2b238d89af6d6c4a4ef'

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
