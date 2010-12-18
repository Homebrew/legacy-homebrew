require 'formula'

class Clay <Formula
  url 'http://tachyon.in/clay/binaries/clay-macosx-2010.11.13.zip'
  homepage 'http://claylanguage.org'
  version '2010.11.13'
  md5 '4039c21970b9ccc1217bc5a731a16914'

  def install
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'clay', bin
  end
end
