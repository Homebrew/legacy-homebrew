require 'formula'

class Haxe <Formula
  url 'http://haxe.org/file/haxe-2.06-osx.tar.gz'
  version '2.06'
  homepage 'http://haxe.org/'
  sha1 '729a10e0b68e53d40928396b961a741724343bea'

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
