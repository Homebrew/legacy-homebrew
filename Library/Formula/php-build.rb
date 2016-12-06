require 'formula'

class PhpBuild < Formula
  url 'https://github.com/CHH/php-build/zipball/v0.1.0'
  homepage 'http://chh.github.com/php-build/'
  md5 'b863f2fd7292e9fe89813e4ae2b3d534'
  head 'https://github.com/CHH/php-build.git'

  def install
    bin.install Dir['bin/php-build']
    share.install Dir['share/php-build']
    man1.install Dir['man/php-build.1']
  end

  def test
    system "php-build --definitions"
  end

  def caveats; <<-EOS.undent
    Tidy is enabled by default which will only work
    on 10.7. Be sure to disable or patch Tidy for
    earlier versions of OS X.
    EOS
  end
end
