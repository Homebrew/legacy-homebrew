require 'stringio'

class Volumes
  def initialize
    @volumes = []
    raw_mounts=`/sbin/mount`
    raw_mounts.split("\n").each do |line|
      case line
      when /^(.+) on (\S+) \(/
        @volumes << [$1, $2]
      end
    end
    # Sort volumes by longest path prefix first
    @volumes.sort! {|a,b| b[1].length <=> a[1].length}
  end

  def which path
    @volumes.each_index do |i|
      vol = @volumes[i]
      return i if vol[1].start_with? path.to_s
    end

    return -1
  end
end


def remove_trailing_slash s
  (s[s.length-1] == '/') ? s[0,s.length-1] : s
end


def path_folders
  ENV['PATH'].split(':').collect{|p| remove_trailing_slash(File.expand_path(p))}.uniq
end


# Installing MacGPG2 interferes with Homebrew in a big way
# http://sourceforge.net/projects/macgpg2/files/
def check_for_macgpg2
  if File.exist? "/Applications/start-gpg-agent.app" or
     File.exist? "/Library/Receipts/libiconv1.pkg"
    puts <<-EOS.undent
      If you have installed MacGPG2 via the package installer, several other
      checks in this script will turn up problems, such as stray .dylibs in
      /usr/local and permissions issues with share and man in /usr/local/.

    EOS
  end
end

def check_for_stray_dylibs
  unbrewed_dylibs = Dir['/usr/local/lib/*.dylib'].select { |f| File.file? f and not File.symlink? f }

  # Dylibs which are generally OK should be added to this list,
  # with a short description of the software they come with.
  white_list = {
    "libfuse.2.dylib" => "MacFuse",
    "libfuse_ino64.2.dylib" => "MacFuse"
  }

  bad_dylibs = unbrewed_dylibs.reject {|d| white_list.key? File.basename(d) }
  return if bad_dylibs.empty?

  puts <<-EOS.undent
    Unbrewed dylibs were found in /usr/local/lib.

    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected dylibs:
  EOS
  puts *bad_dylibs.collect { |f| "    #{f}" }
  puts
end

def check_for_stray_static_libs
  unbrewed_alibs = Dir['/usr/local/lib/*.a'].select { |f| File.file? f and not File.symlink? f }
  return if unbrewed_alibs.empty?

  puts <<-EOS.undent
    Unbrewed static libraries were found in /usr/local/lib.

    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected static libraries:
  EOS
  puts *unbrewed_alibs.collect { |f| "    #{f}" }
  puts
end

def check_for_stray_pcs
  unbrewed_pcs = Dir['/usr/local/lib/pkgconfig/*.pc'].select { |f| File.file? f and not File.symlink? f }

  # Package-config files which are generally OK should be added to this list,
  # with a short description of the software they come with.
  white_list = {
    "fuse.pc" => "MacFuse",
  }

  bad_pcs = unbrewed_pcs.reject {|d| white_list.key? File.basename(d) }
  return if bad_pcs.empty?

  puts <<-EOS.undent
    Unbrewed .pc files were found in /usr/local/lib/pkgconfig.

    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected .pc files:
  EOS
  puts *bad_pcs.collect { |f| "    #{f}" }
  puts
end

def check_for_stray_las
  unbrewed_las = Dir['/usr/local/lib/*.la'].select { |f| File.file? f and not File.symlink? f }

  white_list = {
    "libfuse.la" => "MacFuse",
    "libfuse_ino64.la" => "MacFuse",
  }

  bad_las = unbrewed_las.reject {|d| white_list.key? File.basename(d) }
  return if bad_las.empty?

  puts <<-EOS.undent
    Unbrewed .la files were found in /usr/local/lib.

    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected .la files:
  EOS
  puts *bad_las.collect { |f| "    #{f}" }
  puts
end

def check_for_x11
  unless x11_installed?
    puts <<-EOS.undent
      X11 not installed.

      You don't have X11 installed as part of your OS X installation.
      This isn't required for all formulae, but is expected by some.

    EOS
  end
end

def check_for_nonstandard_x11
  return unless File.exists? '/usr/X11'
  x11 = Pathname.new('/usr/X11')
  if x11.symlink?
    puts <<-EOS.undent
      "/usr/X11" was found, but it is a symlink to:
        #{x11.resolved_path}

      Homebrew's X11 support has only be tested with Apple's X11.
      In particular, "XQuartz" and "XDarwin" are not known to be compatible.

    EOS
  end
end

def check_for_other_package_managers
  if macports_or_fink_installed?
    puts <<-EOS.undent
      You have Macports or Fink installed. This can cause trouble.
      You don't have to uninstall them, but you may like to try temporarily
      moving them away, eg.

        sudo mv /opt/local ~/macports

    EOS
  end
end

def check_gcc_versions
  gcc_42 = gcc_42_build
  gcc_40 = gcc_40_build

  if gcc_42 == nil
    puts <<-EOS.undent
      We couldn't detect gcc 4.2.x. Some formulae require this compiler.

    EOS
  elsif gcc_42 < RECOMMENDED_GCC_42
    puts <<-EOS.undent
      Your gcc 4.2.x version is older than the recommended version. It may be advisable
      to upgrade to the latest release of Xcode.

    EOS
  end

  if MacOS.xcode_version == nil
      puts <<-EOS.undent
        We couldn't detect any version of Xcode.
        If you downloaded Xcode 4.1 from the App Store, you may need to run the installer.

      EOS
  elsif MacOS.xcode_version < "4.0"
    if gcc_40 == nil
      puts <<-EOS.undent
        We couldn't detect gcc 4.0.x. Some formulae require this compiler.

      EOS
    elsif gcc_40 < RECOMMENDED_GCC_40
      puts <<-EOS.undent
        Your gcc 4.0.x version is older than the recommended version. It may be advisable
        to upgrade to the latest release of Xcode.

      EOS
    end
  end
end

def __check_subdir_access base
  target = HOMEBREW_PREFIX+base
  return unless target.exist?

  cant_read = []

  target.find do |d|
    next unless d.directory?
    cant_read << d unless d.writable?
  end

  cant_read.sort!
  if cant_read.length > 0
    puts <<-EOS.undent
    Some folders in #{target} aren't writable.
    This can happen if you "sudo make install" software that isn't managed
    by Homebrew. If a brew tries to add locale information to one of these
    folders, then the install will fail during the link step.
    You should probably `chown` them:

    EOS
    puts *cant_read.collect { |f| "    #{f}" }
    puts
  end
end

def check_access_share_locale
  __check_subdir_access 'share/locale'
end

def check_access_share_man
  __check_subdir_access 'share/man'
end

def __check_folder_access base, msg
  folder = HOMEBREW_PREFIX+base
  return unless folder.exist?

  unless folder.writable?
    puts <<-EOS.undent
      #{folder} isn't writable.
      This can happen if you "sudo make install" software that isn't managed
      by Homebrew.

      #{msg}

      You should probably `chown` #{folder}

    EOS
  end
end

def check_access_pkgconfig
  __check_folder_access 'lib/pkgconfig',
  'If a brew tries to write a .pc file to this folder, the install will\n'+
  'fail during the link step.'
end

def check_access_include
  __check_folder_access 'include',
  'If a brew tries to write a header file to this folder, the install will\n'+
  'fail during the link step.'
end

def check_access_etc
  __check_folder_access 'etc',
  'If a brew tries to write a file to this folder, the install will\n'+
  'fail during the link step.'
end

def check_access_share
  __check_folder_access 'share',
  'If a brew tries to write a file to this folder, the install will\n'+
  'fail during the link step.'
end

def check_usr_bin_ruby
  if /^1\.9/.match RUBY_VERSION
    puts <<-EOS.undent
      Ruby version #{RUBY_VERSION} is unsupported.
      Homebrew is developed and tested on Ruby 1.8.x, and may not work correctly
      on Ruby 1.9.x. Patches are accepted as long as they don't break on 1.8.x.

    EOS
  end
end

def check_homebrew_prefix
  unless HOMEBREW_PREFIX.to_s == '/usr/local'
    puts <<-EOS.undent
      You can install Homebrew anywhere you want, but some brews may only work
      You can install Homebrew anywhere you want, but some brews may only build
      correctly if you install to /usr/local.

    EOS
  end
end

def check_user_path
  seen_prefix_bin = false
  seen_prefix_sbin = false
  seen_usr_bin = false

  path_folders.each do |p|
    if p == '/usr/bin'
      seen_usr_bin = true
      unless seen_prefix_bin
        puts <<-EOS.undent
          /usr/bin is in your PATH before Homebrew's bin. This means that system-
          provided programs will be used before Homebrew-provided ones. This is an
          issue if you install, for instance, Python.

          Consider editing your .bashrc to put:
            #{HOMEBREW_PREFIX}/bin
          ahead of /usr/bin in your $PATH.

        EOS
      end
    end

    seen_prefix_bin  = true if p == "#{HOMEBREW_PREFIX}/bin"
    seen_prefix_sbin = true if p == "#{HOMEBREW_PREFIX}/sbin"
  end

  unless seen_prefix_bin
    puts <<-EOS.undent
      Homebrew's bin was not found in your path. Some brews depend
      on other brews that install tools to bin.

      You should edit your .bashrc to add:
        #{HOMEBREW_PREFIX}/bin
      to $PATH.

      EOS
  end

  # Don't complain about sbin not being in the path if it doesn't exist
  sbin = (HOMEBREW_PREFIX+'sbin')
  if sbin.directory? and sbin.children.length > 0
    unless seen_prefix_sbin
      puts <<-EOS.undent
        Some brews install binaries to sbin instead of bin, but Homebrew's
        sbin was not found in your path.

        Consider editing your .bashrc to add:
          #{HOMEBREW_PREFIX}/sbin
        to $PATH.

        EOS
    end
  end
end

def check_which_pkg_config
  binary = `/usr/bin/which pkg-config`.chomp
  return if binary.empty?

  unless binary == "#{HOMEBREW_PREFIX}/bin/pkg-config"
    puts <<-EOS.undent
      You have a non-brew 'pkg-config' in your PATH:
        #{binary}

      `./configure` may have problems finding brew-installed packages using
      this other pkg-config.

    EOS
  end
end

def check_pkg_config_paths
  binary = `/usr/bin/which pkg-config`.chomp
  return if binary.empty?

  # Use the debug output to determine which paths are searched
  pkg_config_paths = []

  debug_output = `pkg-config --debug 2>&1`
  debug_output.split("\n").each do |line|
    line =~ /Scanning directory '(.*)'/
    pkg_config_paths << $1 if $1
  end

  # Check that all expected paths are being searched
  unless pkg_config_paths.include? "/usr/X11/lib/pkgconfig"
    puts <<-EOS.undent
      Your pkg-config is not checking "/usr/X11/lib/pkgconfig" for packages.
      Earlier versions of the pkg-config formula did not add this path
      to the search path, which means that other formula may not be able
      to find certain dependencies.

      To resolve this issue, re-brew pkg-config with:
        brew rm pkg-config && brew install pkg-config

    EOS
  end
end

def check_for_gettext
  if %w[lib/libgettextlib.dylib
        lib/libintl.dylib
        include/libintl.h ].any? { |f| File.exist? "#{HOMEBREW_PREFIX}/#{f}" }
    puts <<-EOS.undent
      gettext was detected in your PREFIX.

      The gettext provided by Homebrew is "keg-only", meaning it does not
      get linked into your PREFIX by default.

      If you `brew link gettext` then a large number of brews that don't
      otherwise have a `depends_on 'gettext'` will pick up gettext anyway
      during the `./configure` step.

      If you have a non-Homebrew provided gettext, other problems will happen
      especially if it wasn't compiled with the proper architectures.

    EOS
  end
end

def check_for_iconv
  if %w[lib/libiconv.dylib
        include/iconv.h ].any? { |f| File.exist? "#{HOMEBREW_PREFIX}/#{f}" }
    puts <<-EOS.undent
      libiconv was detected in your PREFIX.

      Homebrew doesn't provide a libiconv formula, and expects to link against
      the system version in /usr/lib.

      If you have a non-Homebrew provided libiconv, many formulae will fail
      to compile or link, especially if it wasn't compiled with the proper
      architectures.

    EOS
  end
end

def check_for_config_scripts
  real_cellar = HOMEBREW_CELLAR.exist? && HOMEBREW_CELLAR.realpath

  config_scripts = []

  path_folders.each do |p|
    next if ['/usr/bin', '/usr/sbin', '/usr/X11/bin', "#{HOMEBREW_PREFIX}/bin", "#{HOMEBREW_PREFIX}/sbin"].include? p
    next if p =~ %r[^(#{real_cellar.to_s}|#{HOMEBREW_CELLAR.to_s})] if real_cellar

    configs = Dir["#{p}/*-config"]
    # puts "#{p}\n    #{configs * ' '}" unless configs.empty?
    config_scripts << [p, configs.collect {|p| File.basename(p)}] unless configs.empty?
  end

  unless config_scripts.empty?
    puts <<-EOS.undent
      Some "config" scripts were found in your path, but not in system or Homebrew folders.

      `./configure` scripts often look for *-config scripts to determine if software packages
      are installed, and what additional flags to use when compiling and linking.

      Having additional scripts in your path can confuse software installed via Homebrew if
      the config script overrides a system or Homebrew provided script of the same name.

    EOS

    config_scripts.each do |pair|
      puts pair[0]
      puts "    " + pair[1] * " "
    end
    puts
  end
end

def check_for_dyld_vars
  if ENV['DYLD_LIBRARY_PATH']
    puts <<-EOS.undent
      Setting DYLD_LIBARY_PATH can break dynamic linking.
      You should probably unset it.

    EOS
  end
end

def check_for_symlinked_cellar
  if HOMEBREW_CELLAR.symlink?
    puts <<-EOS.undent
      Symlinked Cellars can cause problems.
      Your Homebrew Cellar is a symlink: #{HOMEBREW_CELLAR}
                      which resolves to: #{HOMEBREW_CELLAR.realpath}

      The recommended Homebrew installations are either:
      (A) Have Cellar be a real folder inside of your HOMEBREW_PREFIX
      (B) Symlink "bin/brew" into your prefix, but don't symlink "Cellar".

      Older installations of Homebrew may have created a symlinked Cellar, but this can
      cause problems when two formula install to locations that are mapped on top of each
      other during the linking step.

    EOS
  end
end

def check_for_multiple_volumes
  return unless HOMEBREW_CELLAR.exist?
  volumes = Volumes.new

  # Find the volumes for the TMP folder & HOMEBREW_CELLAR
  real_cellar = HOMEBREW_CELLAR.realpath

  tmp_prefix = ENV['HOMEBREW_TEMP'] || '/tmp'
  tmp = Pathname.new `/usr/bin/mktemp -d #{tmp_prefix}/homebrew-brew-doctor-XXXX`.strip
  real_temp = tmp.realpath.parent

  where_cellar = volumes.which real_cellar
  where_temp = volumes.which real_temp

  unless where_cellar == where_temp
    puts <<-EOS.undent
      Your Cellar & TEMP folders are on different volumes.

      OS X won't move relative symlinks across volumes unless the target file
      already exists.

      Brews known to be affected by this are Git and Narwhal.

      You should set the "HOMEBREW_TEMP" environmental variable to a suitable
      folder on the same volume as your Cellar.

    EOS
  end
end

def check_for_git
  git = `/usr/bin/which git`.chomp
  if git.empty?
    puts <<-EOS.undent
      "Git" was not found in your path.

      Homebrew uses Git for several internal functions, and some formulae
      use Git checkouts instead of stable tarballs.

      You may want to install git:
        brew install git

    EOS
  end
end

def check_git_newline_settings
  git = `/usr/bin/which git`.chomp
  return if git.empty?

  autocrlf=`git config --get core.autocrlf`
  safecrlf=`git config --get core.safecrlf`

  if autocrlf=='input' and safecrlf=='true'
    puts <<-EOS.undent
    Suspicious Git newline settings found.

    The detected Git newline settings can cause checkout problems:
      core.autocrlf=#{autocrlf}
      core.safecrlf=#{safecrlf}

    If you are not routinely dealing with Windows-based projects,
    consider removing these settings.

    EOS
  end
end

def check_for_autoconf
  autoconf = `/usr/bin/which autoconf`.chomp
  safe_autoconfs = %w[/usr/bin/autoconf /Developer/usr/bin/autoconf]
  unless autoconf.empty? or safe_autoconfs.include? autoconf
    puts <<-EOS.undent
      An "autoconf" in your path blocking the Xcode-provided version at:
        #{autoconf}

      This custom autoconf may cause some Homebrew formulae to fail to compile.

    EOS
  end
end

def __check_linked_brew f
  links_found = []

  Pathname.new(f.prefix).find do |src|
    dst=HOMEBREW_PREFIX+src.relative_path_from(f.prefix)
    next unless dst.symlink?

    dst_points_to = dst.realpath()
    next unless dst_points_to.to_s == src.to_s

    if src.directory?
      Find.prune
    else
      links_found << dst
    end
  end

  return links_found
end

def check_for_linked_kegonly_brews
  require 'formula'

  warnings = Hash.new

  Formula.all.each do |f|
    next unless f.keg_only? and f.installed?
    links = __check_linked_brew f
    warnings[f.name] = links unless links.empty?
  end

  unless warnings.empty?
    puts <<-EOS.undent
    Some keg-only formula are linked into the Cellar.

    Linking a keg-only formula, such as gettext, into the cellar with
    `brew link f` will cause other formulae to detect them during the
    `./configure` step. This may cause problems when compiling those
    other formulae.

    Binaries provided by keg-only formulae may override system binaries
    with other strange results.

    You may wish to `brew unlink` these brews:
    EOS

    puts *warnings.keys.collect { |f| "    #{f}" }
  end
end

def check_for_MACOSX_DEPLOYMENT_TARGET
  target_var = ENV['MACOSX_DEPLOYMENT_TARGET']
  return if target_var.to_s.empty?

  unless target_var == MACOS_VERSION.to_s
    puts <<-EOS.undent
    $MACOSX_DEPLOYMENT_TARGET was set to #{target_var}
    This is used by Fink, but having it set to a value different from the
    current system version (#{MACOS_VERSION}) can cause problems, compiling
    Git for instance, and should probably be removed.

    EOS
  end
end

def check_for_CLICOLOR_FORCE
  target_var = ENV['CLICOLOR_FORCE'].to_s
  unless target_var.empty?
    puts <<-EOS.undent
    $CLICOLOR_FORCE was set to \"#{target_var}\".
    Having $CLICOLOR_FORCE set can cause git builds to fail.

    EOS
  end
end

def check_for_GREP_OPTIONS
  target_var = ENV['GREP_OPTIONS'].to_s
  unless target_var.empty? or target_var == '--color=auto'
    puts <<-EOS.undent
    $GREP_OPTIONS was set to \"#{target_var}\".
    Having $GREP_OPTIONS set this way can cause CMake builds to fail.

    EOS
  end
end

def check_for_other_frameworks
  # Other frameworks that are known to cause problems when present
  ["/Library/Frameworks/expat.framework", "/Library/Frameworks/libexpat.framework"].each do |f|
    if File.exist? f
      puts <<-EOS.undent
        #{f} detected

        This will be picked up by Cmake's build system and likely cause the
        build to fail, trying to link to a 32-bit version of expat.
        You may need to move this file out of the way to compile Cmake.

      EOS
    end
  end

  if File.exist? "/Library/Frameworks/Mono.framework"
    puts <<-EOS.undent
      /Library/Frameworks/Mono.framework detected

      This can be picked up by Cmake's build system and likely cause the
      build to fail, finding improper header files for libpng for instance.

    EOS
  end
end

def check_tmpdir
  tmpdir = ENV['TMPDIR']
  return if tmpdir.nil?
  if !File.directory?(tmpdir)
    puts "$TMPDIR #{tmpdir.inspect} doesn't exist."
    puts
  end
end

module Homebrew extend self
  def doctor
    old_stdout = $stdout
    $stdout = output = StringIO.new

    begin
      check_usr_bin_ruby
      check_homebrew_prefix
      check_for_macgpg2
      check_for_stray_dylibs
      check_for_stray_static_libs
      check_for_stray_pcs
      check_for_stray_las
      check_gcc_versions
      check_for_other_package_managers
      check_for_x11
      check_for_nonstandard_x11
      check_access_include
      check_access_etc
      check_access_share
      check_access_share_locale
      check_access_share_man
      check_user_path
      check_which_pkg_config
      check_pkg_config_paths
      check_access_pkgconfig
      check_for_gettext
      check_for_config_scripts
      check_for_dyld_vars
      check_for_MACOSX_DEPLOYMENT_TARGET
      check_for_CLICOLOR_FORCE
      check_for_GREP_OPTIONS
      check_for_symlinked_cellar
      check_for_multiple_volumes
      check_for_git
      check_git_newline_settings
      check_for_autoconf
      check_for_linked_kegonly_brews
      check_for_other_frameworks
      check_tmpdir
    ensure
      $stdout = old_stdout
    end

    unless (warnings = output.string).chomp.empty?
      puts warnings
      exit 1
    else
      puts "Your OS X is ripe for brewing."
      puts "Any troubles you may be experiencing are likely purely psychosomatic."
    end
  end
end
