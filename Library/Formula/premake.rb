require 'formula'

class Premake < Formula
  url 'http://downloads.sourceforge.net/project/premake/Premake/4.3/premake-4.3-src.zip'
  md5 '8cfafee76f9665c93b2e9ad15b015eb7'
  homepage 'http://industriousone.com/premake'

  def install
    system "make -C build/gmake.macosx"

    # Premake has no install target, but its just a single file that is needed
    bin.install "bin/release/premake4"
  end
end
