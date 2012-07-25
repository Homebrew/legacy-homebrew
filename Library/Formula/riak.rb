require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://downloads.basho.com/riak/riak-1.1.4/riak-1.1.4-osx-x86_64.tar.gz'
    version '1.1.4-x86_64'
    sha256 '7a9d402616ce2dbff2030aff96ac93756b8fe67f4e02fbbe1f1ed812b013da87'
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
