require 'formula'

class Riak < Formula
  homepage 'http://wiki.basho.com/Riak.html'

  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.2/1.2.1/osx/10.4/riak-1.2.1-osx-x86_64.tar.gz'
    version '1.2.1-x86_64'
    sha256 'aa7a99c8cd280a1529b97d690a1faaa0fb05211a87b077cf4f19cb0921cb492b'
  else
    url 'http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.2/1.2.1/osx/10.4/riak-1.2.1-osx-i386.tar.gz'
    version '1.2.1-i386'
    sha256 'a5acbdd1f0a7095557681713158bbc898e7c6f47128bd200bca3840c68aa640a'
  end

  skip_clean :all

  option '32-bit'

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
