require 'formula'

def valgrind?
  ARGV.include? '--with-valgrind'
end

class RBashCompletion < Formula
  # This is the same script that Debian packages use.
  url 'http://rcompletion.googlecode.com/svn-history/r12/trunk/bash_completion/R', :using => :curl
  version 'r12'
  md5 '3c8f6cf1c07e052074ee843be00fa5d6'
end

class R < Formula
  homepage 'http://www.r-project.org'
  url 'http://cran.r-project.org/src/base/R-2/R-2.14.1.tar.gz'
  md5 'ba5b6fb15b660670ea29b885348f322a'

  depends_on 'readline'
  depends_on 'libtiff'
  depends_on 'jpeg'

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

    bash_dir = prefix + 'etc/bash_completion.d'
    bash_dir.mkpath
    RBashCompletion.new.brew { bash_dir.install 'R' }
  end

  def caveats; <<-EOS.undent
    R.framework was installed to:
      #{prefix}/R.framework

    To use this Framework with IDEs such as RStudio, it must be linked
    to the standard OS X location:
      ln -s "#{prefix}/R.framework" /Library/Frameworks

    To enable rJava support, run the following command:
      R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
    EOS
  end
end
