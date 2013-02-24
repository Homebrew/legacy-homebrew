require 'formula'

class Tofrodos < Formula
  homepage 'http://www.thefreecountry.com/tofrodos/'
  url 'http://tofrodos.sourceforge.net/download/tofrodos-1.7.12a.tar.gz'
  sha1 'e4b9f3955dd30193e75a5666f7a95854c3397ce0'

  def install
    cd 'src' do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      ln_s man1+'fromdos.1', man1+'todos.1'
    end
  end
end
