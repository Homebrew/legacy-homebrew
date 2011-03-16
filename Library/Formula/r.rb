require 'formula'

class R < Formula
  url 'http://cran.r-project.org/src/base/R-2/R-2.12.2.tar.gz'
  homepage 'http://www.R-project.org/'
  md5 'bc70b51dddab8aa39066710624e55d5e'

  def install
    ENV.fortran

    system "./configure", "--prefix=#{prefix}",
                          "--with-aqua",
                          "--enable-R-framework",
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

  def caveats; <<-EOS.undent
    R.framework was installed to:
      #{prefix}/R.framework

    To use this Framework with IDEs such as RStudio, it must be linked
    to the standard OS X location:
      ln -s "#{prefix}/R.framework" /Library/Frameworks
    EOS
  end
end
