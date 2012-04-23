require 'formula'

class Ruby < Formula
  homepage 'http://www.ruby-lang.org/en/'
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz'
  sha256 '46e2fa80be7efed51bd9cdc529d1fe22ebc7567ee0f91db4ab855438cf4bd8bb'

  head 'http://svn.ruby-lang.org/repos/ruby/trunk/', :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gdbm'
  depends_on 'libyaml'

  fails_with :llvm do
    build 2326
  end

  # Stripping breaks dynamic linking
  skip_clean :all

  def options
    [
      ["--with-suffix", "Add a 19 suffix to commands"],
      ["--with-doc", "Install with the Ruby documentation"],
      ["--universal", "Compile a universal binary (arch=x86_64,i386)"],
    ]
  end

  def install
    ruby_lib = HOMEBREW_PREFIX+"lib/ruby"

    if File.exist? ruby_lib and File.symlink? ruby_lib
      opoo "#{ruby_lib} exists as a symlink"
      puts <<-EOS.undent
        The previous Ruby formula symlinked #{ruby_lib} into Ruby's Cellar.

        This version creates this as a "real folder" in HOMEBREW_PREFIX
        so that installed gems will survive between Ruby updates.

        Please remove this existing symlink before continuing:
          rm #{ruby_lib}
      EOS
      exit 1
    end

    system "autoconf" unless File.exists? 'configure'

    args = ["--prefix=#{prefix}",
            "--enable-shared"]

    args << "--program-suffix=19" if ARGV.include? "--with-suffix"
    args << "--with-arch=x86_64,i386" if ARGV.build_universal?

    # Put gem, site and vendor folders in the HOMEBREW_PREFIX

    (ruby_lib+'site_ruby').mkpath
    (ruby_lib+'vendor_ruby').mkpath
    (ruby_lib+'gems').mkpath

    (lib+'ruby').install_symlink ruby_lib+'site_ruby',
                                 ruby_lib+'vendor_ruby',
                                 ruby_lib+'gems'

    system "./configure", *args
    system "make"
    system "make install"
    system "make install-doc" if ARGV.include? "--with-doc"

  end

  def caveats; <<-EOS.undent
    NOTE: By default, gem installed binaries will be placed into:
      #{bin}

    You may want to add this to your PATH.
    EOS
  end
end
