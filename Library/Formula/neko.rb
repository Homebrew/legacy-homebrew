require 'formula'

class Neko < Formula
  homepage 'http://nekovm.org'
  url 'http://nekovm.org/_media/neko-2.0.0-osx.tar.gz'
  sha1 '7efe2932e9f3ddb795f758d0958978a4d62d8406'

  def install
    include.install Dir['include/*']
    lib.install 'libneko.dylib'
    bin.install 'neko', 'nekoc', 'nekotools'
    neko = lib + 'neko'
    neko.mkpath
    neko.install Dir['*.ndll']
    neko.install Dir['*.std']
  end

  test do
    system "neko"
  end

  def caveats; <<-EOS.undent
    In order to use the Neko, you will need to export the environment variable:
      export NEKOPATH=#{HOMEBREW_PREFIX}/lib/neko
    EOS
  end
end
