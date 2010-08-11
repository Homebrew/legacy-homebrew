require 'formula'

class Tofrodos <Formula
  url 'http://tofrodos.sourceforge.net/download/tofrodos-1.7.8.tar.gz'
  homepage 'http://www.thefreecountry.com/tofrodos/index.shtml'
  md5 'aaa044f9817a048e126d9eb7a7535e96'

  def install
	  Dir.chdir 'src'
    system "make"
    bin.install %w[todos fromdos]
    man1.install %w[fromdos.1]
    ln_s man1+'fromdos.1', man1+'todos.1'
  end
end
