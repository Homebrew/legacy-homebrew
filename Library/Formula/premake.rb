class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"

  stable do
    url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
    sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  end

  devel do
    url "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha6/premake-5.0.0-alpha6-src.zip"
    sha256 "9c13372699d25824cba1c16a0483507a6a28903e2556ffb148b288c189403aee"
  end

  head do
    url "https://github.com/premake/premake-core.git"
  end

  def install
    if build.head?
      system "make", "-f", "Bootstrap.mak", "osx"
      system "./premake5", "gmake"
    end

    system "make", "-C", "build/gmake.macosx"
    bin.install "bin/release/premake5" if build.devel? or build.head?
    bin.install "bin/release/premake4" if build.stable?
  end

  test do
    system "premake5", "--version" if build.devel? or build.head?
    system "premake4", "--version" if build.stable?
  end
end
