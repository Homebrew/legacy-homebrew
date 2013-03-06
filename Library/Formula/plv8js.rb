require 'formula'

class Plv8js < Formula
  homepage 'https://code.google.com/p/plv8js'

  url 'https://plv8js.googlecode.com/files/plv8-1.4.1.zip'
  sha1 'ceb7579b1fae1c1fe795c03a23471fdf9c7c469e'
  version '1.4.1'

  head 'https://code.google.com/p/plv8js.git'

  depends_on 'v8'
  depends_on 'postgresql'

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
