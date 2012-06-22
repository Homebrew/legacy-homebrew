require 'formula'

class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.6.19/node-v0.6.19.tar.gz'
  sha1 'f6c5cfbadff4788ac3a95f8263a0c2f4e07444b6'

  head 'https://github.com/joyent/node.git'

  devel do
    url 'http://nodejs.org/dist/v0.7.11/node-v0.7.12.tar.gz'
    sha1 '036ab6662287901db9d85df93a5d2a25'
  end

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
    unless ARGV.build_devel?
      inreplace 'wscript' do |s|
        s.gsub! '/usr/local', HOMEBREW_PREFIX
        s.gsub! '/opt/local/lib', '/usr/lib'
      end
    end

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
