require 'formula'

class R < Formula
  homepage 'http://www.r-project.org'
  url 'http://cran.r-project.org/src/base/R-3/R-3.0.1.tar.gz'
  sha1 '5cc65476837926fdf04105954ea94efa53ac85ce'

  head 'https://svn.r-project.org/R/trunk'

  option 'with-openblas', 'Compile linking to OpenBLAS'
  option 'with-valgrind', 'Compile an unoptimized build with support for the Valgrind debugger'
  option 'test', 'Run tests before installing'

  depends_on :fortran
  depends_on 'readline'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on :x11
  depends_on 'valgrind' => :optional
  depends_on 'homebrew/science/openblas' if build.with? 'openblas'

  # This is the same script that Debian packages use.
  resource 'completion' do
    url 'http://rcompletion.googlecode.com/svn-history/r28/trunk/bash_completion/R', :using => :curl
    version 'r28'
    sha1 'af734b8624b33f2245bf88d6782bea0dc5d829a4'
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-aqua",
      "--enable-R-framework",
      "--with-lapack"
    ]

    if build.with? 'valgrind'
      args << '--with-valgrind-instrumentation=2'
      ENV.Og
    end

    args << '--with-blas="-lgoto2"' if build.with? 'openblas'

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

    bash_completion.install resource('completion')

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
