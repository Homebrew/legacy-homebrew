require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.0/riak-1.1.0-osx-x86_64.tar.gz'
    version '1.1.0-x86_64'
    sha256 '4f885a4952661500fd45ef114a1f89c88f8fd40870d4a421a6d7139eaa2966c0'
  else
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.0/riak-1.1.0-osx-i386.tar.gz'
    version '1.1.0-i386'
    sha256 '757a179244a2f8bb811925626eda5df24f15dd0e0b16a4b1337913ecd6a382be'
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
