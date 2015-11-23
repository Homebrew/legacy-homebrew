require "cmd/missing"
require "formula"
require "keg"
require "language/python"
require "version"

class Volumes
  def initialize
    @volumes = get_mounts
  end

  def which(path)
    vols = get_mounts path

    # no volume found
    if vols.empty?
      return -1
    end

    vol_index = @volumes.index(vols[0])
    # volume not found in volume list
    if vol_index.nil?
      return -1
    end
    vol_index
  end

  def get_mounts(path = nil)
    vols = []
    # get the volume of path, if path is nil returns all volumes

    args = %w[/bin/df -P]
    args << path if path

    Utils.popen_read(*args) do |io|
      io.each_line do |line|
        case line.chomp
          # regex matches: /dev/disk0s2   489562928 440803616  48247312    91%    /
        when /^.+\s+[0-9]+\s+[0-9]+\s+[0-9]+\s+[0-9]{1,3}%\s+(.+)/
          vols << $1
        end
      end
    end
    vols
  end
end

class Checks
  ############# HELPERS
  # Finds files in HOMEBREW_PREFIX *and* /usr/local.
  # Specify paths relative to a prefix eg. "include/foo.h".
  # Sets @found for your convenience.
  def find_relative_paths(*relative_paths)
    @found = %W[#{HOMEBREW_PREFIX} /usr/local].uniq.inject([]) do |found, prefix|
      found + relative_paths.map { |f| File.join(prefix, f) }.select { |f| File.exist? f }
    end
  end

  def inject_file_list(list, str)
    list.inject(str) { |s, f| s << "    #{f}\n" }
  end
  ############# END HELPERS

  # Sorry for the lack of an indent here, the diff would have been unreadable.
  # See https://github.com/Homebrew/homebrew/pull/9986
  def check_path_for_trailing_slashes
    bad_paths = ENV["PATH"].split(File::PATH_SEPARATOR).select { |p| p[-1..-1] == "/" }
    return if bad_paths.empty?
    inject_file_list bad_paths, <<-EOS.undent
    Some directories in your path end in a slash.
    Directories in your path should not end in a slash. This can break other
    doctor checks. The following directories should be edited:
    EOS
  end

  # Installing MacGPG2 interferes with Homebrew in a big way
  # https://github.com/GPGTools/MacGPG2
  def check_for_macgpg2
    return if File.exist? "/usr/local/MacGPG2/share/gnupg/VERSION"

    suspects = %w[
      /Applications/start-gpg-agent.app
      /Library/Receipts/libiconv1.pkg
      /usr/local/MacGPG2
    ]

    if suspects.any? { |f| File.exist? f } then <<-EOS.undent
      You may have installed MacGPG2 via the package installer.
      Several other checks in this script will turn up problems, such as stray
      dylibs in /usr/local and permissions issues with share and man in /usr/local/.
    EOS
    end
  end

  def __check_stray_files(dir, pattern, white_list, message)
    return unless File.directory?(dir)

    files = Dir.chdir(dir) do
      Dir[pattern].select { |f| File.file?(f) && !File.symlink?(f) } - Dir.glob(white_list)
    end.map { |file| File.join(dir, file) }

    inject_file_list(files, message) unless files.empty?
  end

  def check_for_stray_dylibs
    # Dylibs which are generally OK should be added to this list,
    # with a short description of the software they come with.
    white_list = [
      "libfuse.2.dylib", # MacFuse
      "libfuse_ino64.2.dylib", # MacFuse
      "libmacfuse_i32.2.dylib", # OSXFuse MacFuse compatibility layer
      "libmacfuse_i64.2.dylib", # OSXFuse MacFuse compatibility layer
      "libosxfuse_i32.2.dylib", # OSXFuse
      "libosxfuse_i64.2.dylib", # OSXFuse
      "libTrAPI.dylib", # TrAPI / Endpoint Security VPN
      "libntfs-3g.*.dylib", # NTFS-3G
      "libntfs.*.dylib", # NTFS-3G
      "libublio.*.dylib", # NTFS-3G
      "libUFSDNTFS.dylib", # Paragon NTFS
      "libUFSDExtFS.dylib", # Paragon ExtFS
    ]

    __check_stray_files "/usr/local/lib", "*.dylib", white_list, <<-EOS.undent
    Unbrewed dylibs were found in /usr/local/lib.
    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected dylibs:
  EOS
  end

  def check_for_stray_static_libs
    # Static libs which are generally OK should be added to this list,
    # with a short description of the software they come with.
    white_list = [
      "libsecurity_agent_client.a", # OS X 10.8.2 Supplemental Update
      "libsecurity_agent_server.a", # OS X 10.8.2 Supplemental Update
      "libntfs-3g.a", # NTFS-3G
      "libntfs.a", # NTFS-3G
      "libublio.a", # NTFS-3G
    ]

    __check_stray_files "/usr/local/lib", "*.a", white_list, <<-EOS.undent
    Unbrewed static libraries were found in /usr/local/lib.
    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected static libraries:
  EOS
  end

  def check_for_stray_pcs
    # Package-config files which are generally OK should be added to this list,
    # with a short description of the software they come with.
    white_list = [
      "fuse.pc", # OSXFuse/MacFuse
      "macfuse.pc", # OSXFuse MacFuse compatibility layer
      "osxfuse.pc", # OSXFuse
      "libntfs-3g.pc", # NTFS-3G
      "libublio.pc", # NTFS-3G
    ]

    __check_stray_files "/usr/local/lib/pkgconfig", "*.pc", white_list, <<-EOS.undent
    Unbrewed .pc files were found in /usr/local/lib/pkgconfig.
    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected .pc files:
  EOS
  end

  def check_for_stray_las
    white_list = [
      "libfuse.la", # MacFuse
      "libfuse_ino64.la", # MacFuse
      "libosxfuse_i32.la", # OSXFuse
      "libosxfuse_i64.la", # OSXFuse
      "libntfs-3g.la", # NTFS-3G
      "libntfs.la", # NTFS-3G
      "libublio.la", # NTFS-3G
    ]

    __check_stray_files "/usr/local/lib", "*.la", white_list, <<-EOS.undent
    Unbrewed .la files were found in /usr/local/lib.
    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected .la files:
  EOS
  end

  def check_for_stray_headers
    white_list = [
      "fuse.h", # MacFuse
      "fuse/**/*.h", # MacFuse
      "macfuse/**/*.h", # OSXFuse MacFuse compatibility layer
      "osxfuse/**/*.h", # OSXFuse
      "ntfs/**/*.h", # NTFS-3G
      "ntfs-3g/**/*.h", # NTFS-3G
    ]

    __check_stray_files "/usr/local/include", "**/*.h", white_list, <<-EOS.undent
    Unbrewed header files were found in /usr/local/include.
    If you didn't put them there on purpose they could cause problems when
    building Homebrew formulae, and may need to be deleted.

    Unexpected header files:
  EOS
  end

  def check_for_other_package_managers
    ponk = MacOS.macports_or_fink
    unless ponk.empty?
      <<-EOS.undent
      You have MacPorts or Fink installed:
        #{ponk.join(", ")}

      This can cause trouble. You don't have to uninstall them, but you may want to
      temporarily move them out of the way, e.g.

        sudo mv /opt/local ~/macports
    EOS
    end
  end

  def check_for_broken_symlinks
    broken_symlinks = []

    Keg::PRUNEABLE_DIRECTORIES.each do |d|
      next unless d.directory?
      d.find do |path|
        if path.symlink? && !path.resolved_path_exists?
          broken_symlinks << path
        end
      end
    end
    return if broken_symlinks.empty?
    inject_file_list broken_symlinks, <<-EOS.undent
    Broken symlinks were found. Remove them with `brew prune`:
    EOS
  end

  def check_for_unsupported_osx
    if !ARGV.homebrew_developer? && OS::Mac.prerelease? then <<-EOS.undent
    You are using OS X #{MacOS.version}.
    We do not provide support for this pre-release version.
    You may encounter build failures or other breakages.
    EOS
    end
  end

  # TODO: distill down into single method definition a la BuildToolsError
  if MacOS.version >= "10.9"
    def check_for_installed_developer_tools
      unless MacOS::Xcode.installed? || MacOS::CLT.installed? then <<-EOS.undent
      No developer tools installed.
      Install the Command Line Tools:
        xcode-select --install
      EOS
      end
    end

    if OS::Mac.prerelease?
      def check_xcode_up_to_date
        if MacOS::Xcode.installed? && MacOS::Xcode.outdated?
          <<-EOS.undent
        Your Xcode (#{MacOS::Xcode.version}) is outdated
        Please update to Xcode #{MacOS::Xcode.latest_version}.
        Xcode can be updated from
          https://developer.apple.com/xcode/downloads/
        EOS
        end
      end
    else
      def check_xcode_up_to_date
        if MacOS::Xcode.installed? && MacOS::Xcode.outdated?
          <<-EOS.undent
        Your Xcode (#{MacOS::Xcode.version}) is outdated
        Please update to Xcode #{MacOS::Xcode.latest_version}.
        Xcode can be updated from the App Store.
        EOS
        end
      end
    end

    def check_clt_up_to_date
      if MacOS::CLT.installed? && MacOS::CLT.outdated? then <<-EOS.undent
      A newer Command Line Tools release is available.
      Update them from Software Update in the App Store.
      EOS
      end
    end
  elsif MacOS.version == "10.8" || MacOS.version == "10.7"
    def check_for_installed_developer_tools
      unless MacOS::Xcode.installed? || MacOS::CLT.installed? then <<-EOS.undent
      No developer tools installed.
      You should install the Command Line Tools.
      The standalone package can be obtained from
        https://developer.apple.com/downloads
      or it can be installed via Xcode's preferences.
      EOS
      end
    end

    def check_xcode_up_to_date
      if MacOS::Xcode.installed? && MacOS::Xcode.outdated? then <<-EOS.undent
      Your Xcode (#{MacOS::Xcode.version}) is outdated
      Please update to Xcode #{MacOS::Xcode.latest_version}.
      Xcode can be updated from
        https://developer.apple.com/xcode/downloads/
      EOS
      end
    end

    def check_clt_up_to_date
      if MacOS::CLT.installed? && MacOS::CLT.outdated? then <<-EOS.undent
      A newer Command Line Tools release is available.
      The standalone package can be obtained from
        https://developer.apple.com/downloads
      or it can be installed via Xcode's preferences.
      EOS
      end
    end
  else
    def check_for_installed_developer_tools
      unless MacOS::Xcode.installed? then <<-EOS.undent
      Xcode is not installed. Most formulae need Xcode to build.
      It can be installed from
        https://developer.apple.com/xcode/downloads/
      EOS
      end
    end

    def check_xcode_up_to_date
      if MacOS::Xcode.installed? && MacOS::Xcode.outdated? then <<-EOS.undent
      Your Xcode (#{MacOS::Xcode.version}) is outdated
      Please update to Xcode #{MacOS::Xcode.latest_version}.
      Xcode can be updated from
        https://developer.apple.com/xcode/downloads/
      EOS
      end
    end
  end

  def check_for_osx_gcc_installer
    if (MacOS.version < "10.7" || MacOS::Xcode.version > "4.1") && \
       MacOS.clang_version == "2.1"
      message = <<-EOS.undent
    You seem to have osx-gcc-installer installed.
    Homebrew doesn't support osx-gcc-installer. It causes many builds to fail and
    is an unlicensed distribution of really old Xcode files.
    EOS
      if MacOS.version >= :mavericks
        message += <<-EOS.undent
          Please run `xcode-select --install` to install the CLT.
        EOS
      elsif MacOS.version >= :lion
        message += <<-EOS.undent
        Please install the CLT or Xcode #{MacOS::Xcode.latest_version}.
      EOS
      else
        message += <<-EOS.undent
        Please install Xcode #{MacOS::Xcode.latest_version}.
      EOS
      end
    end
  end

  def check_for_stray_developer_directory
    # if the uninstaller script isn't there, it's a good guess neither are
    # any troublesome leftover Xcode files
    uninstaller = Pathname.new("/Developer/Library/uninstall-developer-folder")
    if MacOS::Xcode.version >= "4.3" && uninstaller.exist? then <<-EOS.undent
    You have leftover files from an older version of Xcode.
    You should delete them using:
      #{uninstaller}
    EOS
    end
  end

  def check_for_bad_install_name_tool
    return if MacOS.version < "10.9"

    libs = Pathname.new("/usr/bin/install_name_tool").dynamically_linked_libraries

    # otool may not work, for example if the Xcode license hasn't been accepted yet
    return if libs.empty?

    unless libs.include? "/usr/lib/libxcselect.dylib" then <<-EOS.undent
    You have an outdated version of /usr/bin/install_name_tool installed.
    This will cause binary package installations to fail.
    This can happen if you install osx-gcc-installer or RailsInstaller.
    To restore it, you must reinstall OS X or restore the binary from
    the OS packages.
    EOS
    end
  end

  def __check_subdir_access(base)
    target = HOMEBREW_PREFIX+base
    return unless target.exist?

    cant_read = []

    target.find do |d|
      next unless d.directory?
      cant_read << d unless d.writable_real?
    end

    return if cant_read.empty?
    inject_file_list cant_read.sort, <<-EOS.undent
      Some directories in #{target} aren't writable.
      This can happen if you "sudo make install" software that isn't managed
      by Homebrew. If a brew tries to add locale information to one of these
      directories, then the install will fail during the link step.

      You should probably `sudo chown -R $(whoami)` them:
    EOS
  end

  def check_access_share_locale
    __check_subdir_access "share/locale"
  end

  def check_access_share_man
    __check_subdir_access "share/man"
  end

  def check_access_homebrew_repository
    unless HOMEBREW_REPOSITORY.writable_real? then <<-EOS.undent
      The #{HOMEBREW_REPOSITORY} is not writable.

      You should probably change the ownership and permissions of #{HOMEBREW_REPOSITORY}
      back to your user account.
        sudo chown -R $(whoami) #{HOMEBREW_REPOSITORY}
    EOS
    end
  end

  def check_access_usr_local
    return unless HOMEBREW_PREFIX.to_s == "/usr/local"

    unless HOMEBREW_PREFIX.writable_real? then <<-EOS.undent
    The /usr/local directory is not writable.
    Even if this directory was writable when you installed Homebrew, other
    software may change permissions on this directory. Some versions of the
    "InstantOn" component of Airfoil are known to do this.

    You should probably change the ownership and permissions of /usr/local
    back to your user account.
      sudo chown -R $(whoami):admin /usr/local
    EOS
    end
  end

  def check_tmpdir_sticky_bit
    # Repair Disk Permissions was removed(?) in El Capitan.
    # https://support.apple.com/en-us/HT201560
    if MacOS.version < "10.11"
      fix_message = "Please run \"Repair Disk Permissions\" in Disk Utility."
    else
      fix_message = "Please execute `sudo chmod +t #{HOMEBREW_TEMP}` in your Terminal"
    end

    world_writable = HOMEBREW_TEMP.stat.mode & 0777 == 0777
    if world_writable && !HOMEBREW_TEMP.sticky? then <<-EOS.undent
    #{HOMEBREW_TEMP} is world-writable but does not have the sticky bit set.
    #{fix_message}
    EOS
    end
  end

  (Keg::TOP_LEVEL_DIRECTORIES + ["lib/pkgconfig"]).each do |d|
    define_method("check_access_#{d.sub("/", "_")}") do
      dir = HOMEBREW_PREFIX.join(d)
      if dir.exist? && !dir.writable_real? then <<-EOS.undent
      #{dir} isn't writable.

      This can happen if you "sudo make install" software that isn't managed
      by Homebrew. If a formula tries to write a file to this directory, the
      install will fail during the link step.

      You should probably change the ownership and permissions of #{dir}
      back to your user account.
        sudo chown -R $(whoami) #{dir}
      EOS
      end
    end
  end

  def check_access_site_packages
    if Language::Python.homebrew_site_packages.exist? && !Language::Python.homebrew_site_packages.writable_real?
      <<-EOS.undent
      #{Language::Python.homebrew_site_packages} isn't writable.
      This can happen if you "sudo pip install" software that isn't managed
      by Homebrew. If you install a formula with Python modules, the install
      will fail during the link step.

      You should probably change the ownership and permissions of #{Language::Python.homebrew_site_packages}
      back to your user account.
        sudo chown -R $(whoami) #{Language::Python.homebrew_site_packages}
    EOS
    end
  end

  def check_access_logs
    if HOMEBREW_LOGS.exist? && !HOMEBREW_LOGS.writable_real?
      <<-EOS.undent
      #{HOMEBREW_LOGS} isn't writable.
      Homebrew writes debugging logs to this location.

      You should probably change the ownership and permissions of #{HOMEBREW_LOGS}
      back to your user account.
        sudo chown -R $(whoami) #{HOMEBREW_LOGS}
    EOS
    end
  end

  def check_access_cache
    if HOMEBREW_CACHE.exist? && !HOMEBREW_CACHE.writable_real?
      <<-EOS.undent
      #{HOMEBREW_CACHE} isn't writable.
      This can happen if you run `brew install` or `brew fetch` as another user.
      Homebrew caches downloaded files to this location.

      You should probably change the ownership and permissions of #{HOMEBREW_CACHE}
      back to your user account.
        sudo chown -R $(whoami) #{HOMEBREW_CACHE}
    EOS
    end
  end

  def check_access_cellar
    if HOMEBREW_CELLAR.exist? && !HOMEBREW_CELLAR.writable_real?
      <<-EOS.undent
      #{HOMEBREW_CELLAR} isn't writable.

      You should probably change the ownership and permissions of #{HOMEBREW_CELLAR}
      back to your user account.
        sudo chown -R $(whoami) #{HOMEBREW_CELLAR}
    EOS
    end
  end

  def check_access_prefix_opt
    opt = HOMEBREW_PREFIX.join("opt")
    if opt.exist? && !opt.writable_real?
      <<-EOS.undent
      #{opt} isn't writable.
      You should probably change the ownership and permissions of #{opt}
      back to your user account.
        sudo chown -R $(whoami) #{opt}
    EOS
    end
  end

  def check_ruby_version
    ruby_version = MacOS.version >= "10.9" ? "2.0" : "1.8"
    if RUBY_VERSION[/\d\.\d/] != ruby_version then <<-EOS.undent
    Ruby version #{RUBY_VERSION} is unsupported on #{MacOS.version}. Homebrew
    is developed and tested on Ruby #{ruby_version}, and may not work correctly
    on other Rubies. Patches are accepted as long as they don't cause breakage
    on supported Rubies.
    EOS
    end
  end

  def check_homebrew_prefix
    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      <<-EOS.undent
      Your Homebrew is not installed to /usr/local
      You can install Homebrew anywhere you want, but some brews may only build
      correctly if you install in /usr/local. Sorry!
    EOS
    end
  end

  def check_xcode_prefix
    prefix = MacOS::Xcode.prefix
    return if prefix.nil?
    if prefix.to_s.match(" ")
      <<-EOS.undent
      Xcode is installed to a directory with a space in the name.
      This will cause some formulae to fail to build.
    EOS
    end
  end

  def check_xcode_prefix_exists
    prefix = MacOS::Xcode.prefix
    return if prefix.nil?
    unless prefix.exist?
      <<-EOS.undent
      The directory Xcode is reportedly installed to doesn't exist:
        #{prefix}
      You may need to `xcode-select` the proper path if you have moved Xcode.
    EOS
    end
  end

  def check_xcode_select_path
    if !MacOS::CLT.installed? && !File.file?("#{MacOS.active_developer_dir}/usr/bin/xcodebuild")
      path = MacOS::Xcode.bundle_path
      path = "/Developer" if path.nil? || !path.directory?
      <<-EOS.undent
      Your Xcode is configured with an invalid path.
      You should change it to the correct path:
        sudo xcode-select -switch #{path}
    EOS
    end
  end

  # Xcode 7 lacking the 10.10 SDK is forcing sysroot to be declared
  # nil on 10.10 & breaking compiles. CLT is workaround.
  def check_sdk_path_not_nil_yosemite
    if MacOS.version == :yosemite && !MacOS::CLT.installed? && MacOS::Xcode.installed? && MacOS.sdk_path.nil?
      <<-EOS.undent
      Xcode 7 lacks the 10.10 SDK which can cause some builds to fail.
      We recommend installing the Command Line Tools with:
        xcode-select --install
      to resolve this issue.
     EOS
    end
  end

  def check_user_path_1
    $seen_prefix_bin = false
    $seen_prefix_sbin = false

    out = nil

    paths.each do |p|
      case p
      when "/usr/bin"
        unless $seen_prefix_bin
          # only show the doctor message if there are any conflicts
          # rationale: a default install should not trigger any brew doctor messages
          conflicts = Dir["#{HOMEBREW_PREFIX}/bin/*"].
                      map { |fn| File.basename fn }.
                      select { |bn| File.exist? "/usr/bin/#{bn}" }

          if conflicts.size > 0
            out = inject_file_list conflicts, <<-EOS.undent
            /usr/bin occurs before #{HOMEBREW_PREFIX}/bin
            This means that system-provided programs will be used instead of those
            provided by Homebrew. The following tools exist at both paths:
            EOS

            out += <<-EOS.undent

            Consider setting your PATH so that #{HOMEBREW_PREFIX}/bin
            occurs before /usr/bin. Here is a one-liner:
                echo 'export PATH="#{HOMEBREW_PREFIX}/bin:$PATH"' >> #{shell_profile}
          EOS
          end
        end
      when "#{HOMEBREW_PREFIX}/bin"
        $seen_prefix_bin = true
      when "#{HOMEBREW_PREFIX}/sbin"
        $seen_prefix_sbin = true
      end
    end
    out
  end

  def check_user_path_2
    unless $seen_prefix_bin
      <<-EOS.undent
      Homebrew's bin was not found in your PATH.
      Consider setting the PATH for example like so
          echo 'export PATH="#{HOMEBREW_PREFIX}/bin:$PATH"' >> #{shell_profile}
    EOS
    end
  end

  def check_user_path_3
    # Don't complain about sbin not being in the path if it doesn't exist
    sbin = (HOMEBREW_PREFIX+"sbin")
    if sbin.directory? && sbin.children.length > 0
      unless $seen_prefix_sbin
        <<-EOS.undent
        Homebrew's sbin was not found in your PATH but you have installed
        formulae that put executables in #{HOMEBREW_PREFIX}/sbin.
        Consider setting the PATH for example like so
            echo 'export PATH="#{HOMEBREW_PREFIX}/sbin:$PATH"' >> #{shell_profile}
      EOS
      end
    end
  end

  def check_for_bad_curl
    if MacOS.version <= "10.6" && !Formula["curl"].installed? then <<-EOS.undent
      The system curl on 10.6 and below is often incapable of supporting
      modern secure connections & will fail on fetching formulae.
      We recommend you:
        brew install curl
      EOS
    end
  end

  def check_user_curlrc
    if %w[CURL_HOME HOME].any? { |key| ENV[key] && File.exist?("#{ENV[key]}/.curlrc") } then <<-EOS.undent
    You have a curlrc file
    If you have trouble downloading packages with Homebrew, then maybe this
    is the problem? If the following command doesn't work, then try removing
    your curlrc:
      curl https://github.com
    EOS
    end
  end

  def check_for_unsupported_curl_vars
    # Support for SSL_CERT_DIR seemed to be removed in the 10.10.5 update.
    if MacOS.version >= :yosemite && !ENV["SSL_CERT_DIR"].nil? then <<-EOS.undent
      SSL_CERT_DIR support was removed from Apple's curl.
      If fetching formulae fails you should:
        unset SSL_CERT_DIR
      and remove it from #{shell_profile} if present.
      EOS
    end
  end

  def check_which_pkg_config
    binary = which "pkg-config"
    return if binary.nil?

    mono_config = Pathname.new("/usr/bin/pkg-config")
    if mono_config.exist? && mono_config.realpath.to_s.include?("Mono.framework") then <<-EOS.undent
    You have a non-Homebrew 'pkg-config' in your PATH:
      /usr/bin/pkg-config => #{mono_config.realpath}

    This was most likely created by the Mono installer. `./configure` may
    have problems finding brew-installed packages using this other pkg-config.

    Mono no longer installs this file as of 3.0.4. You should
    `sudo rm /usr/bin/pkg-config` and upgrade to the latest version of Mono.
    EOS
    elsif binary.to_s != "#{HOMEBREW_PREFIX}/bin/pkg-config" then <<-EOS.undent
    You have a non-Homebrew 'pkg-config' in your PATH:
      #{binary}

    `./configure` may have problems finding brew-installed packages using
    this other pkg-config.
    EOS
    end
  end

  def check_for_gettext
    find_relative_paths("lib/libgettextlib.dylib",
                        "lib/libintl.dylib",
                        "include/libintl.h")

    return if @found.empty?

    # Our gettext formula will be caught by check_linked_keg_only_brews
    f = Formulary.factory("gettext") rescue nil
    return if f && f.linked_keg.directory? && @found.all? do |path|
      Pathname.new(path).realpath.to_s.start_with? "#{HOMEBREW_CELLAR}/gettext"
    end

    s = <<-EOS.undent_________________________________________________________72
      gettext files detected at a system prefix
      These files can cause compilation and link failures, especially if they
      are compiled with improper architectures. Consider removing these files:
      EOS
    inject_file_list(@found, s)
  end

  def check_for_iconv
    unless find_relative_paths("lib/libiconv.dylib", "include/iconv.h").empty?
      if (f = Formulary.factory("libiconv") rescue nil) && f.linked_keg.directory?
        unless f.keg_only? then <<-EOS.undent
        A libiconv formula is installed and linked
        This will break stuff. For serious. Unlink it.
        EOS
        end
      else
        s = <<-EOS.undent_________________________________________________________72
          libiconv files detected at a system prefix other than /usr
          Homebrew doesn't provide a libiconv formula, and expects to link against
          the system version in /usr. libiconv in other prefixes can cause
          compile or link failure, especially if compiled with improper
          architectures. OS X itself never installs anything to /usr/local so
          it was either installed by a user or some other third party software.

          tl;dr: delete these files:
          EOS
        inject_file_list(@found, s)
      end
    end
  end

  def check_for_config_scripts
    return unless HOMEBREW_CELLAR.exist?
    real_cellar = HOMEBREW_CELLAR.realpath

    scripts = []

    whitelist = %W[
      /usr/bin /usr/sbin
      /usr/X11/bin /usr/X11R6/bin /opt/X11/bin
      #{HOMEBREW_PREFIX}/bin #{HOMEBREW_PREFIX}/sbin
      /Applications/Server.app/Contents/ServerRoot/usr/bin
      /Applications/Server.app/Contents/ServerRoot/usr/sbin
    ].map(&:downcase)

    paths.each do |p|
      next if whitelist.include?(p.downcase) || !File.directory?(p)

      realpath = Pathname.new(p).realpath.to_s
      next if realpath.start_with?(real_cellar.to_s, HOMEBREW_CELLAR.to_s)

      scripts += Dir.chdir(p) { Dir["*-config"] }.map { |c| File.join(p, c) }
    end

    return if scripts.empty?
    inject_file_list scripts, <<-EOS.undent
      "config" scripts exist outside your system or Homebrew directories.
      `./configure` scripts often look for *-config scripts to determine if
      software packages are installed, and what additional flags to use when
      compiling and linking.

      Having additional scripts in your path can confuse software installed via
      Homebrew if the config script overrides a system or Homebrew provided
      script of the same name. We found the following "config" scripts:
    EOS
  end

  def check_DYLD_vars
    found = ENV.keys.grep(/^DYLD_/)
    return if found.empty?
    s = inject_file_list found.map { |e| "#{e}: #{ENV.fetch(e)}" }, <<-EOS.undent
      Setting DYLD_* vars can break dynamic linking.
      Set variables:
    EOS
    if found.include? "DYLD_INSERT_LIBRARIES"
      s += <<-EOS.undent

      Setting DYLD_INSERT_LIBRARIES can cause Go builds to fail.
      Having this set is common if you use this software:
        http://asepsis.binaryage.com/
      EOS
    end
    s
  end

  def check_for_symlinked_cellar
    return unless HOMEBREW_CELLAR.exist?
    if HOMEBREW_CELLAR.symlink?
      <<-EOS.undent
      Symlinked Cellars can cause problems.
      Your Homebrew Cellar is a symlink: #{HOMEBREW_CELLAR}
                      which resolves to: #{HOMEBREW_CELLAR.realpath}

      The recommended Homebrew installations are either:
      (A) Have Cellar be a real directory inside of your HOMEBREW_PREFIX
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

    tmp = Pathname.new(Dir.mktmpdir("doctor", HOMEBREW_TEMP))
    real_temp = tmp.realpath.parent

    where_cellar = volumes.which real_cellar
    where_temp = volumes.which real_temp

    Dir.delete tmp

    unless where_cellar == where_temp then <<-EOS.undent
    Your Cellar and TEMP directories are on different volumes.
    OS X won't move relative symlinks across volumes unless the target file already
    exists. Brews known to be affected by this are Git and Narwhal.

    You should set the "HOMEBREW_TEMP" environmental variable to a suitable
    directory on the same volume as your Cellar.
    EOS
    end
  end

  def check_filesystem_case_sensitive
    volumes = Volumes.new
    case_sensitive_vols = [HOMEBREW_PREFIX, HOMEBREW_REPOSITORY, HOMEBREW_CELLAR, HOMEBREW_TEMP].select do |dir|
      # We select the dir as being case-sensitive if either the UPCASED or the
      # downcased variant is missing.
      # Of course, on a case-insensitive fs, both exist because the os reports so.
      # In the rare situation when the user has indeed a downcased and an upcased
      # dir (e.g. /TMP and /tmp) this check falsely thinks it is case-insensitive
      # but we don't care beacuse: 1. there is more than one dir checked, 2. the
      # check is not vital and 3. we would have to touch files otherwise.
      upcased = Pathname.new(dir.to_s.upcase)
      downcased = Pathname.new(dir.to_s.downcase)
      dir.exist? && !(upcased.exist? && downcased.exist?)
    end.map { |case_sensitive_dir| volumes.get_mounts(case_sensitive_dir) }.uniq
    return if case_sensitive_vols.empty?
    <<-EOS.undent
    The filesystem on #{case_sensitive_vols.join(",")} appears to be case-sensitive.
    The default OS X filesystem is case-insensitive. Please report any apparent problems.
  EOS
  end

  def __check_git_version
    # https://help.github.com/articles/https-cloning-errors
    `git --version`.chomp =~ /git version ((?:\d+\.?)+)/

    if $1 && Version.new($1) < Version.new("1.7.10")
      git_upgrade_cmd = Formula["git"].any_version_installed? ? "upgrade" : "install"

      <<-EOS.undent
        An outdated version of Git was detected in your PATH.
        Git 1.7.10 or newer is required to perform checkouts over HTTPS from GitHub.
        Please upgrade: brew #{git_upgrade_cmd} git
      EOS
    end
  end

  def check_for_git
    if Utils.git_available?
      __check_git_version
    else <<-EOS.undent
    Git could not be found in your PATH.
    Homebrew uses Git for several internal functions, and some formulae use Git
    checkouts instead of stable tarballs. You may want to install Git:
      brew install git
    EOS
    end
  end

  def check_git_newline_settings
    return unless Utils.git_available?

    autocrlf = `git config --get core.autocrlf`.chomp

    if autocrlf == "true" then <<-EOS.undent
    Suspicious Git newline settings found.

    The detected Git newline settings will cause checkout problems:
      core.autocrlf = #{autocrlf}

    If you are not routinely dealing with Windows-based projects,
    consider removing these by running:
    `git config --global core.autocrlf input`
    EOS
    end
  end

  def check_git_origin
    return if !Utils.git_available? || !(HOMEBREW_REPOSITORY/".git").exist?

    origin = Homebrew.git_origin

    if origin.nil? then <<-EOS.undent
      Missing git origin remote.

      Without a correctly configured origin, Homebrew won't update
      properly. You can solve this by adding the Homebrew remote:
        cd #{HOMEBREW_REPOSITORY}
        git remote add origin https://github.com/Homebrew/homebrew.git
      EOS
    elsif origin !~ /(mxcl|Homebrew)\/homebrew(\.git)?$/ then <<-EOS.undent
      Suspicious git origin remote found.

      With a non-standard origin, Homebrew won't pull updates from
      the main repository. The current git origin is:
        #{origin}

      Unless you have compelling reasons, consider setting the
      origin remote to point at the main repository, located at:
        https://github.com/Homebrew/homebrew.git
      EOS
    end
  end

  def check_for_autoconf
    return unless MacOS::Xcode.provides_autotools?

    autoconf = which("autoconf")
    safe_autoconfs = %w[/usr/bin/autoconf /Developer/usr/bin/autoconf]
    unless autoconf.nil? || safe_autoconfs.include?(autoconf.to_s) then <<-EOS.undent
    An "autoconf" in your path blocks the Xcode-provided version at:
      #{autoconf}

    This custom autoconf may cause some Homebrew formulae to fail to compile.
    EOS
    end
  end

  def __check_linked_brew(f)
    f.rack.subdirs.each do |prefix|
      prefix.find do |src|
        next if src == prefix
        dst = HOMEBREW_PREFIX + src.relative_path_from(prefix)
        return true if dst.symlink? && src == dst.resolved_path
      end
    end

    false
  end

  def check_for_linked_keg_only_brews
    return unless HOMEBREW_CELLAR.exist?

    linked = Formula.installed.select do |f|
      f.keg_only? && __check_linked_brew(f)
    end

    return if linked.empty?
    inject_file_list linked.map(&:full_name), <<-EOS.undent
    Some keg-only formula are linked into the Cellar.
    Linking a keg-only formula, such as gettext, into the cellar with
    `brew link <formula>` will cause other formulae to detect them during
    the `./configure` step. This may cause problems when compiling those
    other formulae.

    Binaries provided by keg-only formulae may override system binaries
    with other strange results.

    You may wish to `brew unlink` these brews:
    EOS
  end

  def check_for_other_frameworks
    # Other frameworks that are known to cause problems when present
    %w[expat.framework libexpat.framework libcurl.framework].
      map { |frmwrk| "/Library/Frameworks/#{frmwrk}" }.
      select { |frmwrk| File.exist? frmwrk }.
      map do |frmwrk|
        <<-EOS.undent
      #{frmwrk} detected
      This can be picked up by CMake's build system and likely cause the build to
      fail. You may need to move this file out of the way to compile CMake.
      EOS
      end.join
  end

  def check_tmpdir
    tmpdir = ENV["TMPDIR"]
    "TMPDIR #{tmpdir.inspect} doesn't exist." unless tmpdir.nil? || File.directory?(tmpdir)
  end

  def check_missing_deps
    return unless HOMEBREW_CELLAR.exist?
    missing = Set.new
    Homebrew.missing_deps(Formula.installed).each_value do |deps|
      missing.merge(deps)
    end

    if missing.any? then <<-EOS.undent
    Some installed formula are missing dependencies.
    You should `brew install` the missing dependencies:

        brew install #{missing.sort_by(&:full_name) * " "}

    Run `brew missing` for more details.
    EOS
    end
  end

  def check_git_status
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd do
      unless `git status --untracked-files=all --porcelain -- Library/Homebrew/ 2>/dev/null`.chomp.empty?
        <<-EOS.undent_________________________________________________________72
      You have uncommitted modifications to Homebrew
      If this is a surprise to you, then you should stash these modifications.
      Stashing returns Homebrew to a pristine state but can be undone
      should you later need to do so for some reason.
          cd #{HOMEBREW_LIBRARY} && git stash && git clean -d -f
      EOS
      end
    end
  end

  def check_for_enthought_python
    if which "enpkg" then <<-EOS.undent
    Enthought Python was found in your PATH.
    This can cause build problems, as this software installs its own
    copies of iconv and libxml2 into directories that are picked up by
    other build systems.
    EOS
    end
  end

  def check_for_library_python
    if File.exist?("/Library/Frameworks/Python.framework") then <<-EOS.undent
    Python is installed at /Library/Frameworks/Python.framework

    Homebrew only supports building against the System-provided Python or a
    brewed Python. In particular, Pythons installed to /Library can interfere
    with other software installs.
    EOS
    end
  end

  def check_for_old_homebrew_share_python_in_path
    s = ""
    ["", "3"].map do |suffix|
      if paths.include?((HOMEBREW_PREFIX/"share/python#{suffix}").to_s)
        s += "#{HOMEBREW_PREFIX}/share/python#{suffix} is not needed in PATH.\n"
      end
    end
    unless s.empty?
      s += <<-EOS.undent
      Formerly homebrew put Python scripts you installed via `pip` or `pip3`
      (or `easy_install`) into that directory above but now it can be removed
      from your PATH variable.
      Python scripts will now install into #{HOMEBREW_PREFIX}/bin.
      You can delete anything, except 'Extras', from the #{HOMEBREW_PREFIX}/share/python
      (and #{HOMEBREW_PREFIX}/share/python3) dir and install affected Python packages
      anew with `pip install --upgrade`.
    EOS
    end
  end

  def check_for_bad_python_symlink
    return unless which "python"
    `python -V 2>&1` =~ /Python (\d+)\./
    # This won't be the right warning if we matched nothing at all
    return if $1.nil?
    unless $1 == "2" then <<-EOS.undent
    python is symlinked to python#{$1}
    This will confuse build scripts and in general lead to subtle breakage.
    EOS
    end
  end

  def check_for_non_prefixed_coreutils
    gnubin = "#{Formulary.factory("coreutils").prefix}/libexec/gnubin"
    if paths.include? gnubin then <<-EOS.undent
      Putting non-prefixed coreutils in your path can cause gmp builds to fail.
      EOS
    end
  end

  def check_for_non_prefixed_findutils
    default_names = Tab.for_name("findutils").with? "default-names"
    if default_names then <<-EOS.undent
      Putting non-prefixed findutils in your path can cause python builds to fail.
      EOS
    end
  end

  def check_for_pydistutils_cfg_in_home
    if File.exist? "#{ENV["HOME"]}/.pydistutils.cfg" then <<-EOS.undent
    A .pydistutils.cfg file was found in $HOME, which may cause Python
    builds to fail. See:
      https://bugs.python.org/issue6138
      https://bugs.python.org/issue4655
    EOS
    end
  end

  def check_for_outdated_homebrew
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd do
      if File.directory? ".git"
        local = `git rev-parse -q --verify refs/remotes/origin/master`.chomp
        remote = /^([a-f0-9]{40})/.match(`git ls-remote origin refs/heads/master 2>/dev/null`)
        if remote.nil? || local == remote[0]
          return
        end
      end

      timestamp = if File.directory? ".git"
        `git log -1 --format="%ct" HEAD`.to_i
      else
        HOMEBREW_LIBRARY.mtime.to_i
      end

      if Time.now.to_i - timestamp > 60 * 60 * 24 then <<-EOS.undent
      Your Homebrew is outdated.
      You haven't updated for at least 24 hours. This is a long time in brewland!
      To update Homebrew, run `brew update`.
      EOS
      end
    end
  end

  def check_for_unlinked_but_not_keg_only
    unlinked = Formula.racks.reject do |rack|
      if !(HOMEBREW_REPOSITORY/"Library/LinkedKegs"/rack.basename).directory?
        begin
          Formulary.from_rack(rack).keg_only?
        rescue FormulaUnavailableError, TapFormulaAmbiguityError, TapFormulaWithOldnameAmbiguityError
          false
        end
      else
        true
      end
    end.map(&:basename)

    return if unlinked.empty?
    inject_file_list unlinked, <<-EOS.undent
    You have unlinked kegs in your Cellar
    Leaving kegs unlinked can lead to build-trouble and cause brews that depend on
    those kegs to fail to run properly once built. Run `brew link` on these:
    EOS
  end

  def check_xcode_license_approved
    # If the user installs Xcode-only, they have to approve the
    # license or no "xc*" tool will work.
    if `/usr/bin/xcrun clang 2>&1` =~ /license/ && !$?.success? then <<-EOS.undent
      You have not agreed to the Xcode license.
      Builds will fail! Agree to the license by opening Xcode.app or running:
          sudo xcodebuild -license
      EOS
    end
  end

  def check_for_latest_xquartz
    return unless MacOS::XQuartz.version
    return if MacOS::XQuartz.provided_by_apple?

    installed_version = Version.new(MacOS::XQuartz.version)
    latest_version    = Version.new(MacOS::XQuartz.latest_version)

    return if installed_version >= latest_version

    <<-EOS.undent
      Your XQuartz (#{installed_version}) is outdated
      Please install XQuartz #{latest_version}:
        https://xquartz.macosforge.org
    EOS
  end

  def check_for_old_env_vars
    if ENV["HOMEBREW_KEEP_INFO"]
      <<-EOS.undent
      `HOMEBREW_KEEP_INFO` is no longer used
      info files are no longer deleted by default; you may
      remove this environment variable.
      EOS
    end
  end

  def check_for_pth_support
    homebrew_site_packages = Language::Python.homebrew_site_packages
    return unless homebrew_site_packages.directory?
    return if Language::Python.reads_brewed_pth_files?("python") != false
    return unless Language::Python.in_sys_path?("python", homebrew_site_packages)
    user_site_packages = Language::Python.user_site_packages "python"
    <<-EOS.undent
      Your default Python does not recognize the Homebrew site-packages
      directory as a special site-packages directory, which means that .pth
      files will not be followed. This means you will not be able to import
      some modules after installing them with Homebrew, like wxpython. To fix
      this for the current user, you can run:

        mkdir -p #{user_site_packages}
        echo 'import site; site.addsitedir("#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
    EOS
  end

  def check_for_external_cmd_name_conflict
    cmds = paths.flat_map { |p| Dir["#{p}/brew-*"] }.uniq
    cmds = cmds.select { |cmd| File.file?(cmd) && File.executable?(cmd) }
    cmd_map = {}
    cmds.each do |cmd|
      cmd_name = File.basename(cmd, ".rb")
      cmd_map[cmd_name] ||= []
      cmd_map[cmd_name] << cmd
    end
    cmd_map.reject! { |_cmd_name, cmd_paths| cmd_paths.size == 1 }
    return if cmd_map.empty?
    s = "You have external commands with conflicting names.\n"
    cmd_map.each do |cmd_name, cmd_paths|
      s += inject_file_list cmd_paths, <<-EOS.undent

        Found command `#{cmd_name}` in following places:
      EOS
    end
    s
  end

  def all
    methods.map(&:to_s).grep(/^check_/)
  end
end # end class Checks

module Homebrew
  def doctor
    checks = Checks.new

    if ARGV.include? "--list-checks"
      puts checks.all.sort
      exit
    end

    inject_dump_stats(checks) if ARGV.switch? "D"

    if ARGV.named.empty?
      methods = checks.all.sort
      methods << "check_for_linked_keg_only_brews" << "check_for_outdated_homebrew"
      methods = methods.reverse.uniq.reverse
    else
      methods = ARGV.named
    end

    first_warning = true
    methods.each do |method|
      begin
        out = checks.send(method)
      rescue NoMethodError
        Homebrew.failed = true
        puts "No check available by the name: #{method}"
        next
      end
      unless out.nil? || out.empty?
        if first_warning
          $stderr.puts <<-EOS.undent
            #{Tty.white}Please note that these warnings are just used to help the Homebrew maintainers
            with debugging if you file an issue. If everything you use Homebrew for is
            working fine: please don't worry and just ignore them. Thanks!#{Tty.reset}
          EOS
        end

        $stderr.puts
        opoo out
        Homebrew.failed = true
        first_warning = false
      end
    end

    puts "Your system is ready to brew." unless Homebrew.failed?
  end

  def inject_dump_stats(checks)
    checks.extend Module.new {
      def send(method, *)
        time = Time.now
        super
      ensure
        $times[method] = Time.now - time
      end
    }
    $times = {}
    at_exit do
      puts $times.sort_by { |_k, v| v }.map { |k, v| "#{k}: #{v}" }
    end
  end
end
