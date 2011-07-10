require 'formula'

class GnuProlog < Formula
  url 'http://gprolog.univ-paris1.fr/gprolog-1.4.0.tar.gz'
  homepage 'http://www.gprolog.org/'
  md5 'cc944e5637a04a9184c8aa46c947fd16'

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
