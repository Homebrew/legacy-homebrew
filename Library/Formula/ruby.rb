require 'formula'

class Ruby < Formula
  homepage 'https://www.ruby-lang.org/'
  url 'http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.bz2'
  sha256 '1d3f4ad5f619ec15229206b6667586dcec7cc986672c8fbb8558161ecf07e277'

  head do
    url 'http://svn.ruby-lang.org/repos/ruby/trunk/'
    depends_on :autoconf
  end

  option :universal
  option 'with-suffix', 'Suffix commands with "21"'
  option 'with-doc', 'Install documentation'
  option 'with-tcltk', 'Install with Tcl/Tk support'

  depends_on 'pkg-config' => :build
  depends_on 'readline' => :recommended
  depends_on 'gdbm' => :optional
  depends_on 'libyaml'
  depends_on 'openssl' if MacOS.version >= :mountain_lion
  depends_on :x11 if build.with? 'tcltk'

  fails_with :llvm do
    build 2326
  end

  def install
    system "autoconf" if build.head?

    args = %W[--prefix=#{prefix} --enable-shared --disable-silent-rules]
    args << "--program-suffix=21" if build.with? "suffix"
    args << "--with-arch=#{Hardware::CPU.universal_archs.join(',')}" if build.universal?
    args << "--with-out-ext=tk" unless build.with? "tcltk"
    args << "--disable-install-doc" unless build.with? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?

    # OpenSSL is deprecated on OS X 10.8 and Ruby can't find the outdated
    # version (0.9.8r 8 Feb 2011) that ships with the system.
    # See discussion https://github.com/sstephenson/ruby-build/issues/304
    # and https://github.com/Homebrew/homebrew/pull/18054
    if MacOS.version >= :mountain_lion
      args << "--with-opt-dir=#{Formula.factory('openssl').opt_prefix}"
    end

    # Put gem, site and vendor folders in the HOMEBREW_PREFIX
    ruby_lib = HOMEBREW_PREFIX/"lib/ruby"
    (ruby_lib/'site_ruby').mkpath
    (ruby_lib/'vendor_ruby').mkpath
    (ruby_lib/'gems').mkpath

    (lib/'ruby').install_symlink ruby_lib/'site_ruby',
                                 ruby_lib/'vendor_ruby',
                                 ruby_lib/'gems'

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    By default, gem installed executables will be placed into:
      #{opt_prefix}/bin

    You may want to add this to your PATH. After upgrades, you can run
      gem pristine --all --only-executables

    to restore binstubs for installed gems.
    EOS
  end
end
