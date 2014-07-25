require "formula"

class Premake < Formula
  homepage "http://industriousone.com/premake"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.3/premake-4.3-src.zip"
  sha1 "8f37a3599121580f18b578811162b9b49a2e122f"

  bottle do
    cellar :any
    sha1 "54ccb106b6abf6c1c76a776cffa82d671ab940a2" => :mavericks
    sha1 "960b64d517b1290608acc950058a71f9e984ad79" => :mountain_lion
    sha1 "271358004f8cd52160bfd45d9e58a59bc3fcb75d" => :lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
    sha1 "02472d4304ed9ff66cde57038c17fbd42a159028"
  end

  head do
    url "https://bitbucket.org/premake/premake-dev", :using => :hg

    # An existing premake installation is required to generate the Makefiles
    resource "premake" do
      url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
      sha1 "02472d4304ed9ff66cde57038c17fbd42a159028"
    end
  end

  def install
    if build.stable? or build.devel?
      unless build.devel?
        # Linking against stdc++-static causes a library not found error on 10.7
        inreplace "build/gmake.macosx/Premake4.make", "-lstdc++-static ", ""
      end

      system "make -C build/gmake.macosx"

      # Premake has no install target, but its just a single file that is needed
      bin.install "bin/release/premake4"
    end

    if build.head?
      build_directory = Dir.pwd

      # Build an older version first
      resource("premake").stage do
        system "make -C build/gmake.macosx"

        # And use it to generate the Makefiles for the HEAD version
        premake_directory = Dir.pwd

        Dir.chdir(build_directory) do
          system File.join(premake_directory, "bin/release/premake4"), "embed"
          system File.join(premake_directory, "bin/release/premake4"), "gmake"
        end
      end

      system "make"

      bin.install "bin/release/premake5"
    end
  end
end
