require 'formula'

class Plv8 < Formula
  homepage 'http://code.google.com/p/plv8js/wiki/PLV8'
  version '0.0.20120203'
  url  'https://code.google.com/p/plv8js/', :using => :git, :tag => '1d69da3c36474943a8e2a68037b8f8ca5a102ea7'
  head 'https://code.google.com/p/plv8js/', :using => :git

  depends_on 'v8' # and postgres

  def install
    system 'pg_config' # ensure postgres installed
    system "make"
    system "make install"
  end

  def test
    system "make installcheck"
  end
end
