require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.2/1.2.0/osx/10.4/riak-1.2.0-osx-x86_64.tar.gz'
    version '1.2.0-x86_64'
    sha256 '5681d37377a5efe3553efc2efc1fce81e26168252dc130f7b40d2b6cfa1da9e4'
  else
    url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.2/1.2.0/osx/10.4/riak-1.2.0-osx-i386.tar.gz'
    version '1.2.0-i386'
    sha256 '6af3497fe0918809a8dfcb0e63d70a60b782a66645a59db7dd3e76391f63b33f'
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
