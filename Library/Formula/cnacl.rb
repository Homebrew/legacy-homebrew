require 'formula'

class Cnacl < Formula
  url 'https://github.com/cjdelisle/cnacl/archive/f23fbf8e17771d3623a91db13239f456277ba945.tar.gz.tar.gz'
  homepage 'https://github.com/cjdelisle/cnacl'
  version 'f23fbf8e17771d3623a91db13239f456277ba945'
  sha1 '85a37bdabec48811a05590018290bde070ddf73f'

  depends_on 'cmake' => :build
  conflicts_with 'nacl'

  def install
    ohai "SECURITY WARNING: cnacl's build process is experimental and potentially insecure"
    ohai "Use `brew install nacl` to ensure the software is built securely"

    mkdir 'cbuild' do
      system "cmake .."
      system "make"
      system "make test"

      include.install Dir["include/crypto_*.h"]

      # Add djb's randombytes function so users don't need to provide one
      system "ar", "-r", "libnacl.a", "randombytes/CMakeFiles/randombytes.dir/devurandom/devurandom.o"
      lib.install "libnacl.a"
    end
  end
end
