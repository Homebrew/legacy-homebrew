require 'formula'

class Clay <Formula
  url 'http://tachyon.in/clay/binaries/clay-macosx64-2010.06.24.zip'
  homepage 'http://claylanguage.org'
  version '2010.06.24'
  md5 '4c22d1dbb45174e322d12cbb839f2025'

  def install
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'clay', bin
  end
end
