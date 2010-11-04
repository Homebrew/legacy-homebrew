FORMULA_META_FILES = %w[README README.md ChangeLog COPYING LICENSE LICENCE COPYRIGHT AUTHORS]
PLEASE_REPORT_BUG = "#{Tty.white}Please report this bug at #{Tty.em}http://github.com/mxcl/homebrew/issues#{Tty.reset}"

def check_for_blacklisted_formula names
  return if ARGV.force?

  names.each do |name|
    case name
    when 'tex', 'tex-live', 'texlive' then abort <<-EOS.undent
      Installing TeX from source is weird and gross, requires a lot of patches,
      and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

      We recommend using a MacTeX distribution:
        http://www.tug.org/mactex/
    EOS

    when 'mercurial', 'hg' then abort <<-EOS.undent
      Mercurial can be install thusly:
        brew install pip && pip install mercurial
    EOS

    when 'setuptools' then abort <<-EOS.undent
      When working with a Homebrew-built Python, distribute is preferred
      over setuptools, and can be used as the prerequisite for pip.

      Install distribute using:
        brew install distribute
    EOS
    end
  end
end

def __make url, name
  require 'formula'
  require 'digest'
  require 'erb'

  path = Formula.path(name)
  raise "#{path} already exists" if path.exist?

  if Formula.aliases.include? name and not ARGV.force?
    realname = Formula.resolve_alias(name)
    raise <<-EOS.undent
          "#{name}" is an alias for formula "#{realname}".
          Please check that you are not creating a duplicate.
          To force creation use --force.
          EOS
  end

  if ARGV.include? '--cmake'
    mode = :cmake
  elsif ARGV.include? '--autotools'
    mode = :autotools
  else
    mode = nil
  end

  version = Pathname.new(url).version
  if version.nil?
    opoo "Version cannot be determined from URL."
    puts "You'll need to add an explicit 'version' to the formula."
  else
    puts "Version detected as #{version}."
  end

  md5 = ''
  if ARGV.include? "--cache" and version != nil
    strategy = detect_download_strategy url
    if strategy == CurlDownloadStrategy
      d = strategy.new url, name, version, nil
      the_tarball = d.fetch
      md5 = the_tarball.md5
      puts "MD5 is #{md5}"
    else
      puts "--cache requested, but we can only cache formulas that use Curl."
    end
  end

  formula_template = <<-EOS
require 'formula'

class #{Formula.class_s name} <Formula
  url '#{url}'
  homepage ''
  md5 '#{md5}'

<% if mode == :cmake %>
  depends_on 'cmake'
<% elsif mode == nil %>
  # depends_on 'cmake'
<% end %>

  def install
<% if mode == :cmake %>
    system "cmake . \#{std_cmake_parameters}"
<% elsif mode == :autotools %>
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=\#{prefix}"
<% else %>
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=\#{prefix}"
    # system "cmake . \#{std_cmake_parameters}"
<% end %>
    system "make install"
  end
end
  EOS

  path.write(ERB.new(formula_template, nil, '>').result(binding))
  return path
end

def make url
  path = Pathname.new url

  /(.*?)[-_.]?#{path.version}/.match path.basename

  unless $1.to_s.empty?
    name = $1
  else
    print "Formula name [#{path.stem}]: "
    gots = $stdin.gets.chomp
    if gots.empty?
      name = path.stem
    else
      name = gots
    end
  end

  force_text = "If you really want to make this formula use --force."

  case name.downcase
  when 'vim', 'screen'
    raise <<-EOS
#{name} is blacklisted for creation
Apple distributes this program with OS X.

#{force_text}
    EOS
  when 'libarchive', 'libpcap'
    raise <<-EOS
#{name} is blacklisted for creation
Apple distributes this library with OS X, you can find it in /usr/lib.

#{force_text}
    EOS
  when 'libxml', 'libxlst', 'freetype', 'libpng'
    raise <<-EOS
#{name} is blacklisted for creation
Apple distributes this library with OS X, you can find it in /usr/X11/lib.
However not all build scripts look here, so you may need to call ENV.x11 or
ENV.libxml2 in your formula's install function.

#{force_text}
    EOS
  when 'rubygem'
    raise "Sorry RubyGems comes with OS X so we don't package it.\n\n#{force_text}"
  when 'wxwidgets'
    raise <<-EOS
#{name} is blacklisted for creation
An older version of wxWidgets is provided by Apple with OS X, but
a formula for wxWidgets 2.8.10 is provided:

    brew install wxmac

  #{force_text}
    EOS
  end unless ARGV.force?

  __make url, name
end

def github_info name
  formula_name = Formula.path(name).basename
  user = 'mxcl'
  branch = 'master'

  if system "/usr/bin/which -s git"
    gh_user=`git config --global github.user 2>/dev/null`.chomp
    /^\*\s*(.*)/.match(`git --work-tree=#{HOMEBREW_REPOSITORY} branch 2>/dev/null`)
    unless $1.nil? || $1.empty? || gh_user.empty?
      branch = $1.chomp
      user = gh_user
    end
  end

  return "http://github.com/#{user}/homebrew/commits/#{branch}/Library/Formula/#{formula_name}"
end

def info f
  exec 'open', github_info(f.name) if ARGV.flag? '--github'

  puts "#{f.name} #{f.version}"
  puts f.homepage

  puts "Depends on: #{f.deps.join(', ')}" unless f.deps.empty?

  if f.prefix.parent.directory?
    kids=f.prefix.parent.children
    kids.each do |keg|
      print "#{keg} (#{keg.abv})"
      print " *" if f.installed_prefix == keg and kids.length > 1
      puts
    end
  else
    puts "Not installed"
  end

  if f.caveats
    puts
    puts f.caveats
    puts
  end

  history = github_info(f.name)
  puts history if history

rescue FormulaUnavailableError
  # check for DIY installation
  d=HOMEBREW_PREFIX+name
  if d.directory?
    ohai "DIY Installation"
    d.children.each {|keg| puts "#{keg} (#{keg.abv})"}
  else
    raise "No such formula or keg"
  end
end

def issues_for_formula name
  # bit basic as depends on the issue at github having the exact name of the
  # formula in it. Which for stuff like objective-caml is unlikely. So we
  # really should search for aliases too.

  name = f.name if Formula === name

  require 'open-uri'
  require 'yaml'

  issues = []

  open("http://github.com/api/v2/yaml/issues/search/mxcl/homebrew/open/"+name) do |f|
    YAML::load(f.read)['issues'].each do |issue|
      issues << 'http://github.com/mxcl/homebrew/issues/#issue/%s' % issue['number']
    end
  end

  issues
rescue
  []
end

def cleanup name
  require 'formula'

  f = Formula.factory name
  formula_cellar = f.prefix.parent

  if f.installed? and formula_cellar.directory?
    kids = f.prefix.parent.children
    kids.each do |keg|
      next if f.installed_prefix == keg
      print "Uninstalling #{keg}..."
      FileUtils.rm_rf keg
      puts
    end
  else
    # If the cellar only has one version installed, don't complain
    # that we can't tell which one to keep.
    if formula_cellar.children.length > 1
      opoo "Skipping #{name}: most recent version #{f.version} not installed"
    end
  end
end

def clean f
  require 'cleaner'
  Cleaner.new f
 
  # Hunt for empty folders and nuke them unless they are
  # protected by f.skip_clean?
  # We want post-order traversal, so put the dirs in a stack
  # and then pop them off later.
  paths = []
  f.prefix.find do |path|
    paths << path if path.directory?
  end

  until paths.empty? do
    d = paths.pop
    if d.children.empty? and not f.skip_clean? d
      puts "rmdir: #{d} (empty)" if ARGV.verbose?
      d.rmdir
    end
  end
end


def prune
  $n=0
  $d=0

  dirs=Array.new
  paths=%w[bin sbin etc lib include share].collect {|d| HOMEBREW_PREFIX+d}

  paths.each do |path|
    path.find do |path|
      path.extend ObserverPathnameExtension
      if path.symlink?
        path.unlink unless path.resolved_path_exists?
      elsif path.directory?
        dirs<<path
      end
    end
  end

  dirs.sort.reverse_each {|d| d.rmdir_if_possible}

  if $n == 0 and $d == 0
    puts "Nothing pruned" if ARGV.verbose?
  else
    # always showing symlinks text is deliberate
    print "Pruned #{$n} symbolic links "
    print "and #{$d} directories " if $d > 0
    puts  "from #{HOMEBREW_PREFIX}"
  end
end


def diy
  path=Pathname.getwd

  if ARGV.include? '--set-version'
    version=ARGV.next
  else
    version=path.version
    raise "Couldn't determine version, try --set-version" if version.to_s.empty?
  end
  
  if ARGV.include? '--set-name'
    name=ARGV.next
  else
    path.basename.to_s =~ /(.*?)-?#{version}/
    if $1.nil? or $1.empty?
      name=path.basename
    else
      name=$1
    end
  end

  prefix=HOMEBREW_CELLAR+name+version

  if File.file? 'CMakeLists.txt'
    "-DCMAKE_INSTALL_PREFIX=#{prefix}"
  elsif File.file? 'Makefile.am'
    "--prefix=#{prefix}"
  else
    raise "Couldn't determine build system"
  end
end

def macports_or_fink_installed?
  # See these issues for some history:
  # http://github.com/mxcl/homebrew/issues/#issue/13
  # http://github.com/mxcl/homebrew/issues/#issue/41
  # http://github.com/mxcl/homebrew/issues/#issue/48

  %w[port fink].each do |ponk|
    path = `/usr/bin/which -s #{ponk}`
    return ponk unless path.empty?
  end

  # we do the above check because macports can be relocated and fink may be
  # able to be relocated in the future. This following check is because if
  # fink and macports are not in the PATH but are still installed it can
  # *still* break the build -- because some build scripts hardcode these paths:
  %w[/sw/bin/fink /opt/local/bin/port].each do |ponk|
    return ponk if File.exist? ponk
  end

  # finally, sometimes people make their MacPorts or Fink read-only so they
  # can quickly test Homebrew out, but still in theory obey the README's 
  # advise to rename the root directory. This doesn't work, many build scripts
  # error out when they try to read from these now unreadable directories.
  %w[/sw /opt/local].each do |path|
    path = Pathname.new(path)
    return path if path.exist? and not path.readable?
  end
  
  false
end

def versions_of(keg_name)
  `/bin/ls #{HOMEBREW_CELLAR}/#{keg_name}`.collect { |version| version.strip }.reverse
end


def outdated_brews
  require 'formula'

  results = []
  HOMEBREW_CELLAR.subdirs.each do |keg|
    # Skip kegs with no versions installed
    next unless keg.subdirs

    # Skip HEAD formulae, consider them "evergreen"
    next if keg.subdirs.collect{|p|p.basename.to_s}.include? "HEAD"

    name = keg.basename.to_s
    if (not (f = Formula.factory(name)).installed? rescue nil)
      results << [keg, name, f.version]
    end
  end
  return results
end

def search_brews text
  require "formula"

  return Formula.names if text.to_s.empty?

  rx = if text =~ %r{^/(.*)/$}
    Regexp.new($1)
  else
    /.*#{Regexp.escape text}.*/i
  end

  aliases = Formula.aliases
  results = (Formula.names+aliases).grep rx

  # Filter out aliases when the full name was also found
  results.reject do |alias_name|
    if aliases.include? alias_name
      results.include? Formula.resolve_alias(alias_name)
    end
  end
end

def brew_install
  require 'formula_installer'
  require 'hardware'

  ############################################################ sanity checks
  case Hardware.cpu_type when :ppc, :dunno
    abort "Sorry, Homebrew does not support your computer's CPU architecture.\n"+
          "For PPC support, see: http://github.com/sceaga/homebrew/tree/powerpc"
  end

  raise "Cannot write to #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.exist? and not HOMEBREW_CELLAR.writable?
  raise "Cannot write to #{HOMEBREW_PREFIX}" unless HOMEBREW_PREFIX.writable?

  ################################################################# warnings
  begin
    if MACOS_VERSION >= 10.6
      opoo "You should upgrade to Xcode 3.2.3" if llvm_build < RECOMMENDED_LLVM
    else
      opoo "You should upgrade to Xcode 3.1.4" if (gcc_40_build < RECOMMENDED_GCC_40) or (gcc_42_build < RECOMMENDED_GCC_42)
    end
  rescue
    # the reason we don't abort is some formula don't require Xcode
    # TODO allow formula to declare themselves as "not needing Xcode"
    opoo "Xcode is not installed! Builds may fail!"
  end

  if macports_or_fink_installed?
    opoo "It appears you have MacPorts or Fink installed."
    puts "Software installed with MacPorts and Fink are known to cause problems."
    puts "If you experience issues try uninstalling these tools."
  end

  ################################################################# install!
  installer = FormulaInstaller.new
  installer.install_deps = !ARGV.include?('--ignore-dependencies')

  ARGV.formulae.each do |f|
    if not f.installed? or ARGV.force?
      installer.install f
    else
      puts "Formula already installed: #{f.prefix}"
    end
  end
end

########################################################## class PrettyListing
class PrettyListing
  def initialize path
    Pathname.new(path).children.sort{ |a,b| a.to_s.downcase <=> b.to_s.downcase }.each do |pn|
      case pn.basename.to_s
      when 'bin', 'sbin'
        pn.find { |pnn| puts pnn unless pnn.directory? }
      when 'lib'
        print_dir pn do |pnn|
          # dylibs have multiple symlinks and we don't care about them
          (pnn.extname == '.dylib' or pnn.extname == '.pc') and not pnn.symlink?
        end
      else
        if pn.directory?
          if pn.symlink?
            puts "#{pn} -> #{pn.readlink}"
          else
            print_dir pn
          end
        elsif not (FORMULA_META_FILES.include? pn.basename.to_s or pn.basename.to_s == '.DS_Store')
          puts pn
        end
      end
    end
  end

private
  def print_dir root
    dirs = []
    remaining_root_files = []
    other = ''

    root.children.sort.each do |pn|
      if pn.directory?
        dirs << pn
      elsif block_given? and yield pn
        puts pn
        other = 'other '
      else
        remaining_root_files << pn unless pn.basename.to_s == '.DS_Store'
      end
    end

    dirs.each do |d|
      files = []
      d.find { |pn| files << pn unless pn.directory? }
      print_remaining_files files, d
    end

    print_remaining_files remaining_root_files, root, other
  end

  def print_remaining_files files, root, other = ''
    case files.length
    when 0
      # noop
    when 1
      puts files
    else
      puts "#{root}/ (#{files.length} #{other}files)"
    end
  end
end


def gcc_42_build
  `/usr/bin/gcc-4.2 -v 2>&1` =~ /build (\d{4,})/
  if $1
    $1.to_i 
  elsif system "/usr/bin/which gcc"
    # Xcode 3.0 didn't come with gcc-4.2
    # We can't change the above regex to use gcc because the version numbers
    # are different and thus, not useful.
    # FIXME I bet you 20 quid this causes a side effect — magic values tend to
    401
  else
    nil
  end
end
alias :gcc_build :gcc_42_build # For compatibility

def gcc_40_build
  `/usr/bin/gcc-4.0 -v 2>&1` =~ /build (\d{4,})/
  if $1
    $1.to_i 
  else
    nil
  end
end

def llvm_build
  if MACOS_VERSION >= 10.6
    xcode_path = `/usr/bin/xcode-select -print-path`.chomp
    return nil if xcode_path.empty?
    `#{xcode_path}/usr/bin/llvm-gcc -v 2>&1` =~ /LLVM build (\d{4,})/
    $1.to_i
  end
end

def xcode_version
  `xcodebuild -version 2>&1` =~ /Xcode (\d(\.\d)*)/
  return $1 ? $1 : nil
end

def _compiler_recommendation build, recommended
  message = (!build.nil? && build < recommended) ? "(#{recommended} or newer recommended)" : ""
  return build, message
end
