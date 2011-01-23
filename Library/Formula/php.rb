require 'formula'

class PhpDownloadStrategy <CurlDownloadStrategy
private
  def ext
    return ".tar.bz2"
  end
end

class BundledPhpExtDownloadStrategy < PhpDownloadStrategy
  def initialize url, name, version, specs
    super
    @unique_token="php-#{version}" unless name.to_s.empty? or name == '__UNKNOWN__'
    if @unique_token
      @tarball_path=HOMEBREW_CACHE+(@unique_token+ext)
    else
      @tarball_path=HOMEBREW_CACHE+File.basename(@url)
    end
  end

private
  def chdir
    entries=Dir['*']
    case entries.length
      when 0 then raise "Empty archive"
      when 1 then Dir.chdir entries.first + '/ext' rescue nil
    end
  end
end

class Php <Formula
  url 'http://us.php.net/get/php-5.3.5.tar.bz2/from/this/mirror', :using => PhpDownloadStrategy
  homepage 'http://php.net'
  version '5.3.5'
  md5 '8aaf20c95e91f25c5b6a591e5d6d61b9'

  depends_on 'pkg-config' => :build

  depends_on 'mhash'
  depends_on 'pcre'
  depends_on 'readline'

  def options
    [
      ['--fpm', 'Build with FPM (Fast Process Management) binary'],
      ['--fastcgi', 'Build with FastCGI']
    ]
  end

  def patches
    DATA
  end

  skip_clean :all

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "--sysconfdir=#{etc}/php",
            "--localstatedir=#{HOMEBREW_PREFIX}/var",
            "--with-config-file-path=#{etc}/php",
            "--with-config-file-scan-dir=#{etc}/php/conf.d",
            "--disable-all",
            "--enable-bcmath",
            "--enable-ctype",
            "--enable-dom",
            "--enable-fileinfo",
            "--enable-filter",
            "--enable-hash",
            "--enable-json",
            "--enable-libxml",
            "--enable-pdo",
            "--enable-phar",
            "--enable-session",
            "--enable-simplexml",
            "--enable-tokenizer",
            "--enable-xml",
            "--enable-xmlreader",
            "--enable-xmlwriter",
            "--with-bz2=/usr",
            "--with-pcre-regex=#{HOMEBREW_PREFIX}",
            "--with-mhash=#{HOMEBREW_PREFIX}",
            "--with-readline=#{HOMEBREW_PREFIX}",
            "--with-libxml-dir=/usr",
            "--with-zlib=/usr",
            "--without-pear"]

    if ARGV.include? "--fastcgi"
      args << "--enable-cgi"
    else
      args << "--disable-cgi"
    end

    if ARGV.include? "--fpm"
      args << "--enable-fpm"
    end

    # Fix php-config and phpize to point to HOMEBREW_PREFIX
    inreplace ["./scripts/phpize.in", "./scripts/php-config.in"] do |s|
      s.gsub! /@prefix@/, HOMEBREW_PREFIX
    end

    ENV.append 'LIBS', '-lresolv'
    ENV.append 'PHP_MYSQLND_ENABLED', 'yes'
    ENV.libxml2

    system "./configure", *args
    system "make install"

    etc_php = (etc + "php")

    if not etc_php.exist?
      etc_php.mkdir
    end
    etc_php.install ['php.ini-development', 'php.ini-production']

    if ARGV.include? "--fpm"
      install_args = ['sapi/fpm/php-fpm.conf']

      fpmconfig = (etc_php + "php-fpm.conf")
      @fpm_config_exists = fpmconfig.exist?
      if fpmconfig.exist?
        install_args = { 'sapi/fpm/php-fpm.conf' => 'php-fpm.conf.new' }
      end

      etc_php.install install_args
      (prefix+'org.php-fpm.plist').write startup_plist
    end

    # create the extensions directory to keep it
    # from being linked incorrectly
    mkdir_p `#{bin}/php-config --extension-dir`.strip
  end

  def caveats
    php_ini = etc + "php/php.ini"
    if not php_ini.exist?
      c = <<-CAVEATS
To get started with PHP, you will need to customize it. Depending on the environment
in which you intend to run it, run ONE of the two following commands:
  cp #{php_ini}-development #{php_ini}
  cp #{php_ini}-production #{php_ini}
      CAVEATS
    else
      c = <<-CAVEATS
You may need to update #{php_ini} with any changes that have been made. Depending on the
environment in which you run it, run ONE of the two following commands:
  diff -u #{php_ini} #{php_ini}-development | less
  diff -u #{php_ini} #{php_ini}-production | less
      CAVEATS
    end

    if ARGV.include? "--fpm"
      php_fpm_conf = etc + "php/php-fpm.conf"
      if @fpm_config_exists
        c += <<-FPMCAVEATS

You may need to update #{php_fpm_conf} with any changes that have been made. Run the
following command to see the changes:
  diff -u #{php_fpm_conf}.new #{php_fpm_conf}
        FPMCAVEATS
      end
      c += <<-FPMCAVEATS

You can start php-fpm automatically on login with:
  cp #{prefix}/org.php-fpm.plist ~/Library/LaunchAgents
  launchctl load -w ~/Library/LaunchAgents/org.php-fpm.plist
      FPMCAVEATS
    end

    return c
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.php-fpm</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{sbin}/php-fpm</string>
        <string>--fpm-config</string>
        <string>#{etc}/php/php-fpm.conf</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end
end

class PhpExtensionFormula <Formula
  attr_reader :extension_name

  depends_on 'php'

  def initialize name='__UNKNOWN__', path=nil
    @extension_name=name.split("-", 2)[1]
    super
  end

  class << self
    def self.array_attr_rw(*attrs)
      attrs.each do |attr|
        class_eval %Q{
          def #{attr}(val=nil)
            if val.nil?
              parent_attr = nil
              if self.superclass.respond_to?('#{attr}')
                parent_attr = self.superclass.#{attr}
              end
              if not parent_attr.nil? and not @#{attr}.nil?
                return parent_attr + @#{attr}
              elsif not parent_attr.nil?
                return parent_attr
              elsif not @#{attr}.nil?
                return @#{attr}
              else
                return nil
              end
            else
              @deps = val
            end
          end
        }
      end
    end

    array_attr_rw :deps

    def configure_args(val=nil)
      val.nil? ? (@configure_args) : @configure_args = val
    end
  end

  def configure_args
    @configure_args or self.class.configure_args or []
  end

  def extension_name
    @name.split("-", 2)[1]
  end

  def compile_extension
    system "#{HOMEBREW_PREFIX}/bin/phpize"

    args = ["--prefix=#{prefix}"]
    if not configure_args.nil?
      args += configure_args
    end

    system "./configure", *args

    # Fix Makefile
    inreplace 'Makefile' do |s|
      s.gsub! /^EXTENSION_DIR = #{HOMEBREW_PREFIX}\/lib/, "EXTENSION_DIR = #{lib}"
    end

    system "make"
    system "make install"
  end

  def write_configuration
    (Pathname.new "./#{extension_name}.ini").write config_ini
    (etc + "php/conf.d").install ["#{extension_name}.ini"]
  end

  def install
    compile_extension
    write_configuration
  end

  def config_ini
    standard_config_ini "extension=#{extension_name}.so"
  end

  def standard_config_ini text
    return <<-EOINI
; Do not edit this file; it is automatically generated by Homebrew.
; Any changes you make will be lost if you upgrade or uninstall #{name}.
; To configure PHP, edit #{etc}/php/php.ini.
#{text}
    EOINI
  end
end

class BundledPhpExtensionFormula <PhpExtensionFormula
  def initialize name='__UNKNOWN__', path=nil
    @url = 'http://us.php.net/get/php-5.3.5.tar.bz2/from/this/mirror'
    @specs = { :using => BundledPhpExtDownloadStrategy }
    @stable = SoftwareSpecification.new(@url, @specs)
    @version = '5.3.5'
    @md5 = '8aaf20c95e91f25c5b6a591e5d6d61b9'

    super
  end

  class << self
    def extension_dirs(val=nil)
      val.nil? ? @extension_dirs : @extension_dirs = val
    end
  end

  def extension_dirs
    self.class.extension_dirs or [extension_name]
  end

  def install
    s = ""
    extension_dirs.each do |d|
      Dir.chdir d

      compile_extension

      s += "extension=#{d}\n"

      Dir.chdir '..'
    end

    write_configuration
  end

  def config_ini
    e = extension_dirs.collect {|d| "extension=" + d + ".so" }
    return standard_config_ini e.join("\n")
  end
end

__END__
diff --git a/configure b/configure
index ba58fa8..71ef588 100755
--- a/configure
+++ b/configure
@@ -106580,7 +106580,7 @@ if test -z "$EXTENSION_DIR"; then
       part2=non-zts
     fi
     extbasedir=$part1-$part2-$extbasedir
-    EXTENSION_DIR=$libdir/extensions/$extbasedir
+    EXTENSION_DIR=`brew --prefix`/lib/php/extensions/$extbasedir
   else
     if test "$enable_maintainer_zts" = "yes"; then
       extbasedir=$extbasedir-zts
diff --git a/sapi/fpm/php-fpm.conf.in b/sapi/fpm/php-fpm.conf.in
index 314b7e5..876e45e 100644
--- a/sapi/fpm/php-fpm.conf.in
+++ b/sapi/fpm/php-fpm.conf.in
@@ -22,7 +22,7 @@
 ; Pid file
 ; Note: the default prefix is @EXPANDED_LOCALSTATEDIR@
 ; Default Value: none
-;pid = run/php-fpm.pid
+pid = @EXPANDED_LOCALSTATEDIR@/run/php-fpm.pid
 
 ; Error log file
 ; Note: the default prefix is @EXPANDED_LOCALSTATEDIR@
@@ -56,7 +56,7 @@
 
 ; Send FPM to background. Set to 'no' to keep FPM in foreground for debugging.
 ; Default Value: yes
-;daemonize = yes
+daemonize = no
 
 ;;;;;;;;;;;;;;;;;;;;
 ; Pool Definitions ; 
@@ -154,17 +154,17 @@ pm.max_children = 50
 ; The number of child processes created on startup.
 ; Note: Used only when pm is set to 'dynamic'
 ; Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2
-;pm.start_servers = 20
+pm.start_servers = 20
 
 ; The desired minimum number of idle server processes.
 ; Note: Used only when pm is set to 'dynamic'
 ; Note: Mandatory when pm is set to 'dynamic'
-;pm.min_spare_servers = 5
+pm.min_spare_servers = 5
 
 ; The desired maximum number of idle server processes.
 ; Note: Used only when pm is set to 'dynamic'
 ; Note: Mandatory when pm is set to 'dynamic'
-;pm.max_spare_servers = 35
+pm.max_spare_servers = 35
  
 ; The number of requests each child process should execute before respawning.
 ; This can be useful to work around memory leaks in 3rd party libraries. For
