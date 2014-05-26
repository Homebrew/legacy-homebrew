require 'formula'

class Ruby < Formula
  homepage 'https://www.ruby-lang.org/'
  url "http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.bz2"
  sha256 "6948b02570cdfb89a8313675d4aa665405900e27423db408401473f30fc6e901"

  bottle do
    sha1 "9c7a61fa34c47d0c48a23bf28a0d4c9a3f31b273" => :mavericks
    sha1 "e9e8b27b822b331083f268ac78688e6195d5334a" => :mountain_lion
    sha1 "ccd62b5dd83229a8dfaf57abf8c1ec131b50b17e" => :lion
  end

  head do
    url 'http://svn.ruby-lang.org/repos/ruby/trunk/'
    depends_on "autoconf" => :build
  end

  option :universal
  option 'with-suffix', 'Suffix commands with "21"'
  option 'with-doc', 'Install documentation'
  option 'with-tcltk', 'Install with Tcl/Tk support'

  depends_on 'pkg-config' => :build
  depends_on 'readline' => :recommended
  depends_on 'gdbm' => :optional
  depends_on 'gmp' => :optional
  depends_on 'libffi' => :optional
  depends_on 'libyaml'
  depends_on 'openssl'
  depends_on :x11 if build.with? 'tcltk'

  fails_with :llvm do
    build 2326
  end

  def install
    system "autoconf" if build.head?

    args = %W[--prefix=#{prefix} --enable-shared --disable-silent-rules]
    args << "--program-suffix=21" if build.with? "suffix"
    args << "--with-arch=#{Hardware::CPU.universal_archs.join(',')}" if build.universal?
    args << "--with-out-ext=tk" if build.without? "tcltk"
    args << "--disable-install-doc" if build.without? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?
    args << "--without-gmp" if build.without? "gmp"

    paths = [
      Formula["libyaml"].opt_prefix,
      Formula["openssl"].opt_prefix
    ]

    %w[readline gdbm gmp libffi].each { |dep|
      paths << Formula[dep].opt_prefix if build.with? dep
    }

    args << "--with-opt-dir=#{paths.join(":")}"

    system "./configure", *args
    system "make"
    system "make install"
  end

  def post_install
    # Preserve gem, site, and vendor folders on upgrade/reinstall
    # by placing them in HOMEBREW_PREFIX and sym-linking
    ruby_lib = HOMEBREW_PREFIX/"lib/ruby"

    ["gems", "site_ruby", "vendor_ruby"].each do |name|
      link = lib/"ruby"/name
      real = ruby_lib/name

      # only overwrite invalid (mutually dependent) links
      real.unlink if real.symlink? && real.readlink == link
      real.mkpath

      link.unlink if link.exist?
      link.symlink real
    end
  end

  def caveats; <<-EOS.undent
    By default, gem installed executables will be placed into:
      #{opt_bin}

    You may want to add this to your PATH. After upgrades, you can run
      gem pristine --all --only-executables

    to restore binstubs for installed gems.
    EOS
  end

  test do
    output = `#{bin}/ruby -e 'puts "hello"'`
    assert_equal "hello\n", output
    assert_equal 0, $?.exitstatus
  end
end
