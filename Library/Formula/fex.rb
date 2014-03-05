require 'formula'

class Fex < Formula
  homepage 'http://www.semicomplete.com/projects/fex/'
  url 'https://semicomplete.googlecode.com/files/fex-2.0.0.tar.gz'
  sha1 '014938009ffe0b2ec3d1293154a22e4a40fee4a9'

  def install
    ENV['PREFIX'] = prefix
    system "make install"
  end
end
