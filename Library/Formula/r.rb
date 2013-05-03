require 'formula'

class RBashCompletion < Formula
  # This is the same script that Debian packages use.
  url 'http://rcompletion.googlecode.com/svn-history/r28/trunk/bash_completion/R', :using => :curl
  version 'r28'
  sha1 'af734b8624b33f2245bf88d6782bea0dc5d829a4'
end

class R < Formula
  homepage 'http://www.r-project.org'
  url 'http://cran.r-project.org/src/base/R-3/R-3.0.0.tar.gz'
  sha1 '0cb1d1b815af4ce640ceafd5402a2eb94924c945'

  head 'https://svn.r-project.org/R/trunk'

  option 'with-valgrind', 'Compile an unoptimized build with support for the Valgrind debugger'
  option 'test', 'Run tests before installing'

  depends_on 'readline'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on :x11

  depends_on 'valgrind' if build.include? 'with-valgrind'

  def install
    ENV.Og if build.include? 'with-valgrind'
    ENV.fortran

    args = [
      "--prefix=#{prefix}",
      "--with-aqua",
      "--enable-R-framework",
      "--with-lapack"
    ]
    args << '--with-valgrind-instrumentation=2' if build.include? 'with-valgrind'

    # Pull down recommended packages if building from HEAD.
    system './tools/rsync-recommended' if build.head?

    system "./configure", *args
    system "make"
    ENV.j1 # Serialized installs, please
    system "make check 2>&1 | tee make-check.log" if build.include? 'test'
    system "make install"

    # Link binaries and manpages from the Framework
    # into the normal locations
    bin.mkpath
    man1.mkpath

    ln_s prefix+"R.framework/Resources/bin/R", bin
    ln_s prefix+"R.framework/Resources/bin/Rscript", bin
    ln_s prefix+"R.framework/Resources/man1/R.1", man1
    ln_s prefix+"R.framework/Resources/man1/Rscript.1", man1

    RBashCompletion.new.brew { bash_completion.install 'R' }

    prefix.install 'make-check.log' if build.include? 'test'
  end

  def caveats; <<-EOS.undent
    R.framework was installed to:
      #{opt_prefix}/R.framework

    To use this Framework with IDEs such as RStudio, it must be linked
    to the standard OS X location:
      sudo ln -s "#{opt_prefix}/R.framework" /Library/Frameworks

    To enable rJava support, run the following command:
      R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
    EOS
  end
end
