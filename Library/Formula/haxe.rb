require 'formula'

class Haxe < Formula
  url 'http://haxe.org/file/haxe-2.08-osx.tar.gz'
  version '2.08'
  homepage 'http://haxe.org/'
  sha1 'e8758ea9155bf27606348d02240c2af1fecee67b'

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
