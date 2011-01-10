require 'formula'

class CoffeeScript <Formula
  url 'https://github.com/jashkenas/coffee-script/tarball/0.9.4'
  head 'git://github.com/jashkenas/coffee-script.git'
  homepage 'http://jashkenas.github.com/coffee-script/'
  md5 'f347530b270ec57688d5e614be90cfb9'

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

    Since coffee-script syntax changed pretty drastically between 0.7.2 and
    0.9.x, you may want to install it via npm instead.

    This formula may be retired from a future version of Homebrew.
    EOS
  end
end
