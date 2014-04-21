require 'formula'

class Premake < Formula
  homepage 'http://industriousone.com/premake'
  url 'https://downloads.sourceforge.net/project/premake/Premake/4.3/premake-4.3-src.zip'
  sha1 '8f37a3599121580f18b578811162b9b49a2e122f'

  def install
    # Linking against stdc++-static causes a library not found error on 10.7
    inreplace 'build/gmake.macosx/Premake4.make', '-lstdc++-static ', ''
    system "make -C build/gmake.macosx"

    # Premake has no install target, but its just a single file that is needed
    bin.install "bin/release/premake4"
  end
end
