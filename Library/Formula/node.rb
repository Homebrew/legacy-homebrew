require 'formula'

class Node < Formula
  url 'http://nodejs.org/dist/v0.6.10/node-v0.6.10.tar.gz'
  md5 '8a74fd5d48c2c7c64abc60b2b8f3fbc7'
  homepage 'http://nodejs.org/'
  head 'https://github.com/joyent/node.git'

  devel do
    url 'http://nodejs.org/dist/v0.7.2/node-v0.7.2.tar.gz'
    md5 '4fced93a0bbb9c38a8e6685b9d404c6c'
  end

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?

  fails_with_llvm :build => 2326

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [["--debug", "Build with debugger hooks."]]
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
    args << "--debug" if ARGV.include? '--debug'

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
