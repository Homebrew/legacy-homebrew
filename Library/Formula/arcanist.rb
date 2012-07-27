require 'formula'

class Arcanist < Formula
  class Libphutil < Formula
    url 'https://github.com/facebook/libphutil/zipball/1f9e0d9b699c5cb1f6624aad7bed60309e05f1e4'
    sha1 '74916edbb1432005334fe0fd04a2f873319fc4b6'
  end

  homepage 'http://phabricator.org'
  url 'https://github.com/facebook/arcanist/zipball/5be656aa57166fbe4416802c9403023bfd9aeff5'
  version '1.0.0'
  sha1 'd6dff7de3a0ef5d00cb38b53888eb940fd3eeeee'

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
end
