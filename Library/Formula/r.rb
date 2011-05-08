require 'formula'

def valgrind?
  ARGV.include? '--with-valgrind'
end

class R < Formula
  url 'http://cran.r-project.org/src/base/R-2/R-2.13.0.tar.gz'
  homepage 'http://www.R-project.org/'
  md5 'ecfb928067cfd932e75135f8b8bba3e7'

  depends_on 'valgrind' if valgrind?

  def options
    [
      ['--with-valgrind', 'Compile an unoptimized build with support for the Valgrind debugger.']
    ]
  end

  def install
    if valgrind?
      ENV.remove_from_cflags /-O./
      ENV.append_to_cflags '-O0'
    end

    ENV.fortran
    ENV.x11 # So PNG gets added to the x11 and cairo plotting devices
    ENV['OBJC'] = ENV['CC']
    ENV['OBJCFLAGS'] = ENV['CFLAGS']

    args = [
      "--prefix=#{prefix}",
      "--with-aqua",
      "--enable-R-framework",
      "--with-lapack"
    ]
    args << '--with-valgrind-instrumentation=2' if valgrind?

    system "./configure", *args
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
