require 'formula'

class Haxe < Formula
  url 'http://haxe.org/file/haxe-2.07-osx.tar.gz'
  version '2.07'
  homepage 'http://haxe.org/'
  sha1 '0958a13077aedef1b304d4b43b6eb5d6041bdf88'

  def install
    bin.install %w(haxe haxedoc haxelib)
    (share+"haxe").install "std"
  end

  def caveats; <<-EOS.undent
    HaXe needs to know how to find its standard library so add this to your
    shell profile:
      export HAXE_LIBRARY_PATH="`brew --prefix`/share/haxe/std"'
    EOS
  end
end
