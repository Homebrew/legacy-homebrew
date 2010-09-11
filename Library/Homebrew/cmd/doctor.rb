class Volumes
  def initialize
    @volumes = []
    raw_mounts=`mount`
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
      return i if is_prefix?(vol[1], path)
    end

    return -1
  end
end


def is_prefix? prefix, longer_string
  p = prefix.to_s
  longer_string.to_s[0,p.length] == p
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

  opoo "Unbrewed dylibs were found in /usr/local/lib"
  puts <<-EOS.undent
    You have unbrewed dylibs in /usr/local/lib. If you didn't put them there on purpose,
    they could cause problems when building Homebrew formulae.

    Unexpected dylibs (delete if they are no longer needed):
  EOS
  puts *bad_dylibs.collect { |f| "    #{f}" }
  puts
end

def check_for_x11
  unless x11_installed?
    opoo "X11 not installed."
    puts <<-EOS.undent
      You don't have X11 installed as part of your Xcode installation.
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

def check_cc_symlink
    which_cc = Pathname.new('/usr/bin/cc').realpath.basename.to_s
    if which_cc == "llvm-gcc-4.2"
      puts <<-EOS.undent
        You changed your cc to symlink to llvm.
        This bypasses LLVM checks, and some formulae may mysteriously fail to work.
        You may want to change /usr/bin/cc to point back at gcc.

        To force Homebrew to use LLVM, you can set the "HOMEBREW_LLVM" environmental
        variable, or pass "--use-llvm" to "brew install".

      EOS
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

def check_access_pkgconfig
  # If PREFIX/lib/pkgconfig already exists, "sudo make install" of
  # non-brew installed software may cause installation failures.
  pkgconfig = HOMEBREW_PREFIX+'lib/pkgconfig'
  return unless pkgconfig.exist?

  unless pkgconfig.writable?
    puts <<-EOS.undent
      #{pkgconfig} isn't writable.
      This can happen if you "sudo make install" software that isn't managed
      by Homebrew. If a brew tries to write a .pc file to this folder, the
      install will fail during the link step.

      You should probably `chown` #{pkgconfig}

    EOS
  end
end

def check_access_include
  # Installing MySQL manually (for instance) can chown include to root.
  include_folder = HOMEBREW_PREFIX+'include'
  return unless include_folder.exist?

  unless include_folder.writable?
    puts <<-EOS.undent
      #{include_folder} isn't writable.
      This can happen if you "sudo make install" software that isn't managed
      by Homebrew. If a brew tries to write a header file to this folder, the
      install will fail during the link step.

      You should probably `chown` #{include_folder}

    EOS
  end
end

def check_access_etc
  etc_folder = HOMEBREW_PREFIX+'etc'
  return unless etc_folder.exist?

  unless etc_folder.writable?
    puts <<-EOS.undent
      #{etc_folder} isn't writable.
      This can happen if you "sudo make install" software that isn't managed
      by Homebrew. If a brew tries to write a file to this folder, the install
      will fail during the link step.

      You should probably `chown` #{etc_folder}

    EOS
  end
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
      correctly if you install to /usr/local.

    EOS
  end
end

def check_user_path
  seen_prefix_bin = false
  seen_prefix_sbin = false
  seen_usr_bin = false

  paths = ENV['PATH'].split(':').collect{|p| File.expand_path p}

  paths.each do |p|
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
  real_cellar = HOMEBREW_CELLAR.realpath

  config_scripts = []

  paths = ENV['PATH'].split(':').collect{|p| File.expand_path p}
  paths.each do |p|
    next if ['/usr/bin', '/usr/sbin', '/usr/X11/bin', "#{HOMEBREW_PREFIX}/bin", "#{HOMEBREW_PREFIX}/sbin"].include? p
    next if p =~ %r[^(#{real_cellar.to_s}|#{HOMEBREW_CELLAR.to_s})]

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
  volumes = Volumes.new

  # Find the volumes for the TMP folder & HOMEBREW_CELLAR
  real_cellar = HOMEBREW_CELLAR.realpath

  tmp_prefix = ENV['HOMEBREW_TEMP'] || '/tmp'
  tmp=Pathname.new `/usr/bin/mktemp -d #{tmp_prefix}/homebrew-brew-doctor-XXXX`.strip
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

      You may want to do:
        brew install git

    EOS
  end
end

def check_for_autoconf
  which_autoconf = `/usr/bin/which autoconf`.chomp
  unless (which_autoconf == '/usr/bin/autoconf' or which_autoconf == '/Developer/usr/bin/autoconf')
    puts <<-EOS.undent
      You have an "autoconf" in your path blocking the system version at:
        #{which_autoconf}

      Custom autoconf in general and autoconf 2.66 in particular has issues
      and will cause some Homebrew formulae to fail.

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

def check_for_other_vars
  target_var = ENV['MACOSX_DEPLOYMENT_TARGET']
  return if target_var.nil? or target_var.empty?

  unless target_var == MACOS_VERSION.to_s
    puts <<-EOS.undent
    $MACOSX_DEPLOYMENT_TARGET was set to #{target_var}
    This is used by Fink, but having it set to a value different from the
    current system version (#{MACOS_VERSION}) can cause problems, compiling
    Git for instance, and should probably be removed.

    EOS
  end
end

module Homebrew extend self
def doctor
  read, write = IO.pipe

  if fork == nil
    read.close
    $stdout.reopen write

    check_usr_bin_ruby
    check_homebrew_prefix
    check_for_macgpg2
    check_for_stray_dylibs
    check_gcc_versions
    check_cc_symlink
    check_for_other_package_managers
    check_for_x11
    check_for_nonstandard_x11
    check_access_share_locale
    check_access_share_man
    check_access_include
    check_access_etc
    check_user_path
    check_which_pkg_config
    check_pkg_config_paths
    check_access_pkgconfig
    check_for_gettext
    check_for_config_scripts
    check_for_dyld_vars
    check_for_other_vars
    check_for_symlinked_cellar
    check_for_multiple_volumes
    check_for_git
    check_for_autoconf
    check_for_linked_kegonly_brews

    exit! 0
  else
    write.close

    unless (out = read.read).chomp.empty?
      puts out
    else
      puts "Your OS X is ripe for brewing."
      puts "Any troubles you may be experiencing are likely purely psychosomatic."
    end
  end
end
end
