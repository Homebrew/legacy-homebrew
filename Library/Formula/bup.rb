require 'formula'

class Bup < Formula
  homepage 'https://github.com/bup/bup'
  head 'https://github.com/bup/bup.git', :branch => 'master'
  url 'https://github.com/bup/bup/archive/0.25-rc4.tar.gz'
  version '0.25-rc4'
  sha1 'f3dc0539443587390d9a720cf49a48e33b24317b'

  option "run-tests", "Run unit tests after compilation"

  depends_on :python

  def install
    python do
      system "make"
    end
    system "make test" if build.include? "run-tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
