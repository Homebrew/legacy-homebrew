require 'formula'

class Plv8 < Formula
  homepage 'http://code.google.com/p/plv8js/wiki/PLV8'
  version '1.4.1'
  url 'https://plv8js.googlecode.com/files/plv8-1.4.1.zip'
  sha1 'ceb7579b1fae1c1fe795c03a23471fdf9c7c469e'

  head 'https://code.google.com/p/plv8js/', :using => :git

  depends_on 'v8' # and postgres
  depends_on :postgresql

  def install
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system 'pg_config' # ensure postgres installed
    system "make"
    system "make install"
  end

  def test
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system "make installcheck"
  end
end
