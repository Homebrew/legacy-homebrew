require 'formula'

class Haxe < Formula
  homepage 'http://haxe.org'
  url 'http://haxe.org/file/haxe-3.0.0-osx.tar.gz'
  sha1 '8363385b3716ecba48ca1b5690cdf479a83c25ef'

  depends_on 'neko'

  def install
    bin.install 'haxe', 'haxedoc', 'haxelib'
    haxe = lib + 'haxe'
    haxe.mkpath
    haxe.install 'std'
  end

  test do
    system "haxe"
  end

  def caveats; <<-EOS.undent
    In order to use the Haxe, you will need to export these environment variables:
      export HAXE_HOME=#{HOMEBREW_PREFIX}/lib/haxe
      export HAXE_STD_PATH=#{HOMEBREW_PREFIX}/lib/haxe/std:.:/
    EOS
  end
end
