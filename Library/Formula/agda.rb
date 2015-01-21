require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  homepage "http://wiki.portal.chalmers.se/agda/"
  url "http://hackage.haskell.org/package/Agda-2.4.2.2/Agda-2.4.2.2.tar.gz"
  sha1 "fbdf7df3d5a036e683210ac7ccf4f8ec0c9fea05"

  devel do
    url "https://github.com/agda/agda.git", :branch => "maint-2.4.2"
    version "2.4.2.3-beta"
  end

  head "https://github.com/agda/agda.git", :branch => "master"

  option "without-epic-backend", "Exclude the 'epic' compiler backend"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"
  depends_on "bdw-gc" if build.with? "epic-backend"

  def install
    if build.with? "epic-backend"
      epicFlag = "-fepic"
    else
      epicFlag = "-f-epic"
    end
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "cpphs"
      cabal_install "--only-dependencies", epicFlag
      cabal_install "--prefix=#{prefix}", epicFlag
    end
    cabal_clean_lib
  end

  test do
    system "#{bin}/agda", "--test"
  end
end
