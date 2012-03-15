require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.1/riak-1.1.1-osx-x86_64.tar.gz'
    version '1.1.1x86_64'
    sha256 '5d3ab7810459ff40608522cfe2e231078b5fa40adc405bdeddd734ffef47bb9e'
  else
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.1/1.1.1/riak-1.1.1-osx-i386.tar.gz'
    version '1.1.1-i386'
    sha256 '2f977f0c9bed8838a17c50aac515fc2e1c009feb5c83e7da463fd3dd1fee3e95'
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
