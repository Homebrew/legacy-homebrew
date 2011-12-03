require 'formula'

class Node < Formula
  url 'http://nodejs.org/dist/v0.6.4/node-v0.6.4.tar.gz'
  head 'https://github.com/joyent/node.git'
  homepage 'http://nodejs.org/'
  md5 'a170bef450de365720223c3af3747bf7'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?

  fails_with_llvm :build => 2326

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [["--debug", "Build with debugger hooks."]]
  end

  def install
    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', HOMEBREW_PREFIX
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

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
      Homebrew has NOT installed npm. We recommend the following method of
      installation:
        curl http://npmjs.org/install.sh | sh

      After installing, add the following path to your NODE_PATH enviornment
      variable to have npm libraries picked up:
        #{HOMEBREW_PREFIX}/lib/node_modules
    EOS
  end
end
