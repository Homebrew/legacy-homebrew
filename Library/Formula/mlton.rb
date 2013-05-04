require 'formula'

# Installs the binary build of MLton.
# Since MLton is written in ML, building from source
# would require an existing ML compiler/interpreter for bootstrapping.

class StandardHomebrewLocation < Requirement
  satisfy HOMEBREW_PREFIX.to_s == "/usr/local"

  def message; <<-EOS.undent
    mlton won't work outside of /usr/local

    Because this uses pre-compiled binaries, it will not work if
    Homebrew is installed somewhere other than /usr/local; mlton
    will be unable to find GMP.
    EOS
  end
end

class Mlton < Formula
  homepage 'http://mlton.org'
  url 'http://downloads.sourceforge.net/project/mlton/mlton/20100608/mlton-20100608-1.amd64-darwin.gmp-static.tgz'
  sha1 'b5e067f2f3d2166d074602f83b03004587f3adab'

  # We download and install the version of MLton which is statically linked to libgmp, but all
  # generated executables will require gmp anyway, hence the dependency
  depends_on StandardHomebrewLocation
  depends_on 'gmp'

  def install
    cd "local" do
      # Remove OS X droppings
      rm Dir["man/man1/._*"]
      mv "man", "share"
      prefix.install Dir['*']
    end
  end
end
