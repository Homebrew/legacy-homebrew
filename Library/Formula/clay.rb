require 'formula'

class Clay < Formula
  url 'http://tachyon.in/clay/binaries/clay-macosx-2011.04.18.zip'
  homepage 'http://claylanguage.org'
  md5 '9f43d8147f95ce0d7c3cd12e368406a4'

  def install
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'clay', bin
  end
end
