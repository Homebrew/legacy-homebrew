require 'formula'

class R <Formula
  url 'http://cran.r-project.org/src/base/R-2/R-2.12.1.tar.gz'
  homepage 'http://www.R-project.org/'
  md5 '078e8d1179fc9a762e326e6da2725468'

  def install
    unless `/usr/bin/which gfortran`.chomp.size > 0
      opoo 'No gfortran found in path'
      puts "You'll need to `brew install gfortran` or otherwise have a copy"
      puts "of gfortran in your path for this brew to work."
    end

    ENV["FCFLAGS"] = ENV["CFLAGS"]
    ENV["FFLAGS"]  = ENV["CFLAGS"]

    system "./configure", "--prefix=#{prefix}", "--with-aqua", "--enable-R-framework",
           "--with-lapack"
    system "make"
    ENV.j1 # Serialized installs, please
    system "make install"

    # Link binaries and manpages from the Framework
    # into the normal locations
    bin.mkpath
    man1.mkpath

    ln_s prefix+"R.framework/Resources/bin/R", bin
    ln_s prefix+"R.framework/Resources/bin/Rscript", bin
    ln_s prefix+"R.framework/Resources/man1/R.1", man1
    ln_s prefix+"R.framework/Resources/man1/Rscript.1", man1
  end
end
