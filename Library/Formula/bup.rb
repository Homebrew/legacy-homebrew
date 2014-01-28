require 'formula'

class Bup < Formula
  homepage 'https://github.com/bup/bup'
  head 'https://github.com/bup/bup.git', :branch => 'master'
  url 'https://github.com/bup/bup/archive/0.25.tar.gz'
  sha1 'f32ba39582d0e8875632f282c54f7377ed2a4df9'

  option "run-tests", "Run unit tests after compilation"

  def install
    system "make"
    system "make test" if build.include? "run-tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
