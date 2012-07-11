require 'formula'

def valgrind?
  ARGV.include? '--with-valgrind'
end

class RBashCompletion < Formula
  # This is the same script that Debian packages use.
  url 'http://rcompletion.googlecode.com/svn-history/r28/trunk/bash_completion/R', :using => :curl
  version 'r28'
  md5 'd5493f7a8422147c2f5c63c6a18ebda4'
end

class R < Formula
  homepage 'http://www.r-project.org'
  url 'http://cran.r-project.org/src/base/R-2/R-2.15.1.tar.gz'
  sha1 'f0e6912be6dfc0d1fdc4be66048304d8befe8424'

  head 'https://svn.r-project.org/R/trunk'

  depends_on 'readline'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on :x11

  depends_on 'valgrind' if valgrind?

  def options
    [
      ['--with-valgrind', 'Compile an unoptimized build with support for the Valgrind debugger.']
    ]
  end

  def install
    ENV.Og if valgrind?
    ENV.fortran

    args = [
      "--prefix=#{prefix}",
      "--with-aqua",
      "--enable-R-framework",
      "--with-lapack"
    ]
    args << '--with-valgrind-instrumentation=2' if valgrind?

    # Pull down recommended packages if building from HEAD.
    system './tools/rsync-recommended' if ARGV.build_head?

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
