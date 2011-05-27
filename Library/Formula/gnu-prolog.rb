require 'formula'

class GnuProlog < Formula
  url 'http://gprolog.univ-paris1.fr/unstable/gprolog-20110301.tgz'
  homepage 'http://www.gprolog.org/'
  md5 '53a9bfba78f21f8f45a16f049d5df88a'

  skip_clean :all

  def install
    ENV.j1 # make won't run in parallel

    Dir.chdir 'src' do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install-strip"
    end
  end
end
