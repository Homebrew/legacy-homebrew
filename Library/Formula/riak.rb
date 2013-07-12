require 'formula'

class Riak < Formula
  homepage 'http://docs.basho.com/riak/latest/'
  url 'http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.0/osx/10.8/riak-1.4.0-OSX-x86_64.tar.gz'
  version '1.4.0-x86_64'
  sha256 '4830b9e00b520b8494264017bfc2ff10753fd51b9e013bafd3054e29e5be1443'

  depends_on :arch => :x86_64

  skip_clean 'libexec'

  def install
    libexec.install Dir['*']

    # These scripts don't dereference symlinks correctly.
    # Point them to #{libexec}.
    inreplace(Dir["#{libexec}/bin/*"]) do |s|
      a = %($(cd ${0%/*} && pwd)/../)
      b = %(#{libexec}/)
      s.gsub! a, b
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

end
