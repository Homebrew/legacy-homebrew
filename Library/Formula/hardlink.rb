require 'formula'

class Hardlink < Formula
  homepage 'https://github.com/selkhateeb/hardlink'
  url 'https://github.com/selkhateeb/hardlink.git'
  sha1 'efc88e9710e534475078a33e5a58d3a0dd2f1974'
  version '1.0' # I don't quite understand where this comes from

  def install
    system "make"
    system "make install"
  end

end
