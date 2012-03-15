require 'formula'

class Tofrodos < Formula
  homepage 'http://www.thefreecountry.com/tofrodos/index.shtml'
  url 'http://tofrodos.sourceforge.net/download/tofrodos-1.7.8.tar.gz'
  md5 'aaa044f9817a048e126d9eb7a7535e96'

  def install
    cd 'src' do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      ln_s man1+'fromdos.1', man1+'todos.1'
    end
  end
end
