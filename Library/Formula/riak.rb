require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.2/1.2.0rc1/osx/10.4/riak-1.2.0rc1-osx-i386.tar.gz'
    version '1.2.0-x86_64'
    sha256 '06578043c211b82866986e0cf470bccd1bf6ccc6c2f8ed3cc69a3c6d333d8060'
  else
    url 'http://downloads.basho.com/riak/riak-1.1.4/riak-1.1.4-osx-i386.tar.gz'
    version '1.1.4-i386'
    sha256 'bde5fec665d758754f47353592875791fda054bc4b71acee44a62e4915853abc'
  end

  skip_clean :all

  def options
    [['--32-bit', 'Build 32-bit only.']]
  end

  def install
    libexec.install Dir['*']

    # The scripts don't dereference symlinks correctly.
    # Help them find stuff in libexec. - @adamv
    inreplace Dir["#{libexec}/bin/*"] do |s|
      s.change_make_var! "RUNNER_SCRIPT_DIR", "#{libexec}/bin"
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
