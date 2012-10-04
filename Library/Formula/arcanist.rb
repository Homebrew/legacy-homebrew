require 'formula'

class Arcanist < Formula
  class Libphutil < Formula
    url 'https://github.com/facebook/libphutil/zipball/795212bf9d7a87397b8ada3926d11a88efdd556b'
    sha1 'cd3eca0063e744ce6724fcc68f747090fa4f31f6'
    version '1.0.1'
  end

  homepage 'http://phabricator.org'
  url 'https://github.com/facebook/arcanist/zipball/d0425fc238c3255f1436f311424121255adfab62'
  version '1.0.1'
  sha1 '8c7f8be79e2c5cefe13e17feb8cde141e01794f6'

  def install
    Libphutil.new.brew do
      (prefix + "libphutil/").install Dir['*']
    end

    (prefix + "arcanist/").install %w{bin externals resources scripts src}
    bin.install_symlink prefix + "arcanist/bin/arc"
  end

  def test
    system "arc help"
  end

  def caveats
    <<-EOS.undent
    Now check out http://www.phabricator.com/docs/phabricator/article/Arcanist_User_Guide.html#overview
    EOS
  end
end
