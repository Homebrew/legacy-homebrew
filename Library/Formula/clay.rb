require 'formula'

class Clay <Formula
  url 'http://tachyon.in/clay/binaries/clay-macosx64-2010.07.29.zip'
  homepage 'http://claylanguage.org'
  version '2010.07.29'
  md5 '6c7e318915e65f6db0ac65cb0aca0fdd'

  def install
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'clay', bin
  end
end
