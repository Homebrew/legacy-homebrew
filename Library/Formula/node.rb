require 'formula'

class Node < Formula
  url 'http://nodejs.org/dist/v0.6.3/node-v0.6.3.tar.gz'
  head 'https://github.com/joyent/node.git'
  homepage 'http://nodejs.org/'
  md5 'e9c72081c2a1141128e53f84dcba3f0e'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?

  fails_with_llvm :build => 2326

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [["--debug", "Build with debugger hooks."]]
  end

  # apply temporary patch until 0.6.4 is available
  # see: https://github.com/mxcl/homebrew/pull/8784
  def patches
    "https://github.com/joyent/node/commit/3ca0517.patch"
  end 

  def install
    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

    ohai "Homebrew is skipping npm install..."
    
    args = ["--prefix=#{prefix}", "--without-npm"]
    args << "--debug" if ARGV.include? '--debug'

    # v0.6 appears to have a bug in parallel building
    # so we'll -j1 it for now
    ENV.deparallelize

    system "./configure", *args
    system "make install"
  end

  def caveats
    <<-EOS.undent
        Homebrew has NOT installed npm.  Please use 'curl http://npmjs.org/install.sh | sh' to install.
        Please add #{HOMEBREW_PREFIX}/lib/node_modules to your NODE_PATH environment variable to have node libraries picked up.
    EOS
  end
end
