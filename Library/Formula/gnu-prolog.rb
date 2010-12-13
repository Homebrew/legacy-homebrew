require 'formula'

class GnuProlog <Formula
  url 'http://gprolog.univ-paris1.fr/unstable/gprolog-20100713.tgz'
  homepage 'http://www.gprolog.org/'
  md5 '0f882e352b886a5ddb59bcab457fa78e'

  skip_clean :all

  def install
    ENV.j1 # make won't run in parallel

    Dir.chdir 'src' do
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make"
      system "make install-strip"
    end
  end
end
