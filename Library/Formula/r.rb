require 'formula'

class R <Formula
  url 'http://cran.r-project.org/src/base/R-2/R-2.11.0.tar.gz'
  homepage 'http://www.R-project.org/'
  md5 'c6c1e866299f533617750889c729bfb3'
  
  depends_on 'gfortran'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "mkdir #{prefix}/bin"
    system "ln -s #{prefix}/R.framework/Resources/bin/R #{prefix}/bin/R"
    system "ln -s #{prefix}/R.framework/Resources/bin/Rscript #{prefix}/bin/Rscript"
    system "mkdir -p #{prefix}/share/man/man1"
    system "ln -s #{prefix}/R.framework/Resources/man1/R.1 #{prefix}/share/man/man1/R.1"
    system "ln -s #{prefix}/R.framework/Resources/man1/Rscript.1 #{prefix}/share/man/man1/Rscript.1"
  end
end
