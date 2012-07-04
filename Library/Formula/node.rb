require 'formula'

class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.8.1/node-v0.8.1.tar.gz'
  sha1 '892790553b8121ba8624d8293d0cb7d8b01094d7'

  head 'https://github.com/joyent/node.git'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?

  fails_with :llvm do
    build 2326
  end

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [["--enable-debug", "Build with debugger hooks."]]
  end

  def install
    # Why skip npm install? Read https://github.com/mxcl/homebrew/pull/8784.
    args = ["--prefix=#{prefix}", "--without-npm"]
    args << "--debug" if ARGV.include? '--enable-debug'

    system "./configure", *args
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Homebrew has NOT installed npm. We recommend the following method of
      installation:
        curl http://npmjs.org/install.sh | sh

      After installing, add the following path to your NODE_PATH environment
      variable to have npm libraries picked up:
        #{HOMEBREW_PREFIX}/lib/node_modules
    EOS
  end
end
