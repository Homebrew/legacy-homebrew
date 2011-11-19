require 'formula'

class CoffeeScript < Formula
  url 'https://github.com/jashkenas/coffee-script/tarball/1.1.3'
  head 'https://github.com/jashkenas/coffee-script.git'
  homepage 'http://jashkenas.github.com/coffee-script/'
  md5 '0919b917f0c1bda3bbac218b2a9baf48'

  # head coffee-script usually depends on head node and
  # since there isn't a way to specify that just remove
  # the depends_on
  depends_on 'node' unless ARGV.build_head?

  def install
    bin.mkpath
    system "./bin/cake", "--prefix", prefix, "install"
  end

  def caveats; <<-EOS.undent
    coffee-script can also be installed via `npm install coffee-script`.
    This has the advantage of supporting multiple versions (of any Node libs)
    at the same time.

    You may want to install coffee-script via npm.

    This formula may be retired from a future version of Homebrew.
    EOS
  end
end
