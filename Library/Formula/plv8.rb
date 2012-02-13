require 'formula'

class Plv8 < Formula
  homepage 'http://code.google.com/p/plv8js/wiki/PLV8'
  version '0.0.20120203'
  url  'https://code.google.com/p/plv8js/', :using => :git, :tag => '1d69da3c36474943a8e2a68037b8f8ca5a102ea7'
  head 'https://code.google.com/p/plv8js/', :using => :git

  depends_on 'v8' # and postgres

  def install
    begin
      system 'which -s pg_config'
    rescue BuildError
      onoe 'Unable to find Postgres. Building PLV8 will fail without Postgres.'
      puts 'Please install Postgres and ensure `pg_config` works.'
    end
    system "make"
    system "make install"
  end
end
