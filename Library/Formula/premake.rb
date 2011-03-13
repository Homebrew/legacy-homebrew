require 'formula'

class Premake < Formula
  url 'http://downloads.sourceforge.net/project/premake/Premake/4.1.2/premake-4.1.2-src.zip'
  md5 'de11ee2ba611ffe6e00ba190e35d2c41'
  homepage 'http://industriousone.com/premake'

  def install
    system "make -C build/gmake.macosx"

    # Premake has no install target, but its just a single file that is needed
    bin.install "bin/release/premake4"
  end
end
