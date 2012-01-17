require 'formula'

class CoffeeScript < Formula
  url 'http://github.com/jashkenas/coffee-script/tarball/1.2.0'
  head 'https://github.com/jashkenas/coffee-script.git'
  homepage 'http://jashkenas.github.com/coffee-script/'
  md5 '5dfc3ee21214f1b7e86c0535f5386a35'

  # head coffee-script usually depends on head node and
  # since there isn't a way to specify that just remove
  # the depends_on
  depends_on 'node' unless ARGV.build_head?

  def install
    bin.mkpath
    system "./bin/cake", "--prefix", prefix, "install"
  end

  def caveats; <<-EOS.undent
    coffee-script can also be installed via npm with:
      npm install coffee-script

    This has the advantage of supporting multiple versions of Node libs
    at the same time.
    EOS
  end
end
