require 'formula'

class CoffeeScript <Formula
  url 'http://github.com/jashkenas/coffee-script/tarball/0.7.2'
  head 'git://github.com/jashkenas/coffee-script.git'
  homepage 'http://jashkenas.github.com/coffee-script/'
  md5 'cfccf25272d329bc78349771b18fe4e0'

  # head coffee-script usually depends on head node and
  # since there isn't a way to specify that just remove
  # the depends_on
  depends_on 'node' unless ARGV.build_head?

  def caveats; <<-EOS.undent
    coffee-script can also be installed via `npm install coffee-script`.
    This has the advantage of supporting multiple versions (of any Node libs)
    at the same time. Since coffee-script syntax changed pretty drastically
    between 0.7.2 and 0.9, you may want to install it via npm instead.

    This formula may be retired from a future version of Homebrew.
    EOS
  end if ARGV.build_head?

  def install
    bin.mkpath
    system "./bin/cake", "--prefix", prefix, "install"
  end
end
