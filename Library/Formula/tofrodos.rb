require 'formula'

class Tofrodos < Formula
  homepage 'http://www.thefreecountry.com/tofrodos/index.shtml'
  url 'http://tofrodos.sourceforge.net/download/tofrodos-1.7.9.tar.gz'
  sha1 '3b2b0ddec1629e42bb17cf323d7518fd079191ed'

  def install
    cd 'src' do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      ln_s man1+'fromdos.1', man1+'todos.1'
    end
  end
end
