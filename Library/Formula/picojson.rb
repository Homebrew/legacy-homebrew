require 'formula'

class Picojson < Formula
  homepage 'https://github.com/kazuho/picojson'
  url 'https://github.com/kazuho/picojson/tarball/53411f2055ceb427041ce6609de0a5f8751198c1'
  sha1 '673d864442b2de4d529a106739e1fe28af711271'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
