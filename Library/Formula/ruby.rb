require 'formula'

class Ruby < Formula
  homepage 'http://www.ruby-lang.org/en/'
  url 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.bz2'
  mirror 'http://mirrorservice.org/sites/ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.bz2'
  sha256 '08e3d4b85b8a1118a8e81261f59dd8b4ddcfd70b6ae554e0ec5ceb99c3185e8a'

  head 'http://svn.ruby-lang.org/repos/ruby/trunk/'

  option :universal
  option 'with-suffix', 'Suffix commands with "20"'
  option 'with-doc', 'Install documentation'
  option 'with-tcltk', 'Install with Tcl/Tk support'

  if build.universal?
    depends_on 'autoconf' => :build
  elsif build.head?
    depends_on :autoconf
  end

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

    args = %W[--prefix=#{prefix} --enable-shared]
    args << "--program-suffix=20" if build.with? "suffix"
    args << "--with-arch=#{Hardware::CPU.universal_archs.join(',')}" if build.universal?
    args << "--with-out-ext=tk" unless build.with? "tcltk"
    args << "--disable-install-doc" unless build.with? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?

    # OpenSSL is deprecated on OS X 10.8 and Ruby can't find the outdated
    # version (0.9.8r 8 Feb 2011) that ships with the system.
    # See discussion https://github.com/sstephenson/ruby-build/issues/304
    # and https://github.com/mxcl/homebrew/pull/18054
    if MacOS.version >= :mountain_lion
      args << "--with-openssl-dir=#{Formula.factory('openssl').opt_prefix}"
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
    NOTE: By default, gem installed binaries will be placed into:
      #{opt_prefix}/bin

    You may want to add this to your PATH.
    EOS
  end
end
