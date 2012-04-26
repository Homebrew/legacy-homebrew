require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.2/riak-1.1.2-osx-x86_64.tar.gz'
    version '1.1.2-x86_64'
    sha256 '84ca1068125abcbe9bcab47be3222ffbb7f8bca2125d5b6005af8ec33460a266'
  else
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.2/riak-1.1.2-osx-i386.tar.gz'
    version '1.1.2-i386'
    sha256 'b2d1783aa1cf95870b4902c6770d9e17e272d3f24f49ae593811abe490a5aa91'
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
