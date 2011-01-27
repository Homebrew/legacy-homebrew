require 'formula'

class RubyGems <Formula
  url 'http://rubyforge.org/frs/download.php/69365/rubygems-1.3.6.tgz'
  homepage 'http://docs.rubygems.org/'
  md5 '789ca8e9ad1d4d3fe5f0534fcc038a0d'
end

class Ruby18 <Formula
  url 'ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6.tar.gz'
  homepage 'http://ruby-lang.org/'
  md5 '23d2494aa94e7ae1ecbbb8c5e1507683'

  depends_on 'readline5'

  def options
    [
      ["--with-suffix", "Add a 18 suffix to commands"],
    ]
  end

  def install
    # Check Ruby Library directory
    username = ENV["USER"]
    ruby_version = version.split('.')[0..1].join('.')
    ruby_dir = Pathname.new '/Library/Ruby'
    if (not ruby_dir.exist?) or (not ruby_dir.writable?)
      raise <<-EOS
For proper installation of Ruby #{ruby_version} on Mac OS X #{MACOS_VERSION},
the following directory must be owned and writable by user `#{username}':

    #{ruby_dir}

before attempting to install Ruby #{ruby_version}.
      EOS
    end

    # Create Ruby Library directories
    site_dir = (ruby_dir + 'Site')
    site_dir.mkpath unless site_dir.exist?
    site_lib_dir = (site_dir + ruby_version)
    site_lib_dir.mkpath unless site_lib_dir.exist?
    gem_home = (ruby_dir + 'Gems' + ruby_version)
    gem_home.mkpath unless gem_home.exist?
    gem_doc_dir = (gem_home + 'doc')
    gem_doc_dir.mkpath unless gem_doc_dir.exist?

    # Build Ruby
    args = [ "--prefix=#{prefix}",
             "--libdir=#{libexec}",
             "--with-sitedir=#{site_dir}",
             "--with-readline-dir=#{HOMEBREW_PREFIX}",
             "--disable-debug",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--enable-pthread" ]

    args << "--program-suffix=18" if ARGV.include? "--with-suffix"

    system "./configure", *args
    inreplace "config.h", "/lib/ruby/", "/libexec/ruby/"
    inreplace "mkconfig.rb", /^EOS/, "#{framework_hack}\nEOS"
    system "make"
    system "make install"

    # Build RubyGems
    RubyGems.new.brew do
       system "#{prefix}/bin/ruby", "setup.rb"
    end
  end

  # This is so RubyGems will correctly define the Gems home under
  # the /Library/Ruby/Gems location like Leopard does.
  def framework_hack; <<-EOS.undent
    RUBY_FRAMEWORK = false
    RUBY_FRAMEWORK_VERSION = Config::CONFIG['ruby_version']
    EOS
  end
end
