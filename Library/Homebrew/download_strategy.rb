require 'open-uri'
require 'utils/json'

class AbstractDownloadStrategy
  attr_accessor :local_bottle_path

  def initialize name, package
    @url = package.url
    specs = package.specs
    @spec, @ref = specs.dup.shift unless specs.empty?
  end

  def expand_safe_system_args args
    args = args.dup
    args.each_with_index do |arg, ii|
      if arg.is_a? Hash
        unless ARGV.verbose?
          args[ii] = arg[:quiet_flag]
        else
          args.delete_at ii
        end
        return args
      end
    end
    # 2 as default because commands are eg. svn up, git pull
    args.insert(2, '-q') unless ARGV.verbose?
    args
  end

  def quiet_safe_system *args
    safe_system(*expand_safe_system_args(args))
  end

  # All download strategies are expected to implement these methods
  def fetch; end
  def stage; end
  def cached_location; end
end

class CurlDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super

    if name.to_s.empty? || name == '__UNKNOWN__'
      @tarball_path = Pathname.new("#{HOMEBREW_CACHE}/#{basename_without_params}")
    else
      @tarball_path = Pathname.new("#{HOMEBREW_CACHE}/#{name}-#{package.version}#{ext}")
    end

    @mirrors = package.mirrors
    @temporary_path = Pathname.new("#@tarball_path.incomplete")
  end

  def cached_location
    @tarball_path
  end

  def downloaded_size
    @temporary_path.size? or 0
  end

  # Private method, can be overridden if needed.
  def _fetch
    curl @url, '-C', downloaded_size, '-o', @temporary_path
  end

  def fetch
    ohai "Downloading #{@url}"
    unless @tarball_path.exist?
      had_incomplete_download = @temporary_path.exist?
      begin
        _fetch
      rescue ErrorDuringExecution
        # 33 == range not supported
        # try wiping the incomplete download and retrying once
        if $?.exitstatus == 33 && had_incomplete_download
          ohai "Trying a full download"
          @temporary_path.unlink
          had_incomplete_download = false
          retry
        else
          raise CurlDownloadStrategyError, "Download failed: #{@url}"
        end
      end
      ignore_interrupts { @temporary_path.rename(@tarball_path) }
    else
      puts "Already downloaded: #{@tarball_path}"
    end
  rescue CurlDownloadStrategyError
    raise if @mirrors.empty?
    puts "Trying a mirror..."
    @url = @mirrors.shift
    retry
  else
    @tarball_path
  end

  def stage
    ohai "Pouring #{File.basename(@tarball_path)}" if @tarball_path.to_s.match bottle_regex

    case @tarball_path.compression_type
    when :zip
      with_system_path { quiet_safe_system 'unzip', {:quiet_flag => '-qq'}, @tarball_path }
      chdir
    when :gzip_only
      # gunzip writes the compressed data in the location of the original,
      # regardless of the current working directory; the only way to
      # write elsewhere is to use the stdout
      with_system_path do
        target = File.basename(basename_without_params, ".gz")

        IO.popen("gunzip -f '#{@tarball_path}' -c") do |pipe|
          File.open(target, "w") do |f|
            buf = ""
            f.write(buf) while pipe.read(1024, buf)
          end
        end
      end
    when :gzip, :bzip2, :compress, :tar
      # Assume these are also tarred
      # TODO check if it's really a tar archive
      with_system_path { safe_system 'tar', 'xf', @tarball_path }
      chdir
    when :xz
      raise "You must install XZutils: brew install xz" unless File.executable? xzpath
      with_system_path { safe_system "#{xzpath} -dc \"#{@tarball_path}\" | tar xf -" }
      chdir
    when :pkg
      safe_system '/usr/sbin/pkgutil', '--expand', @tarball_path, basename_without_params
      chdir
    when :rar
      raise "You must install unrar: brew install unrar" unless which "unrar"
      quiet_safe_system 'unrar', 'x', {:quiet_flag => '-inul'}, @tarball_path
    when :p7zip
      raise "You must install 7zip: brew install p7zip" unless which "7zr"
      safe_system '7zr', 'x', @tarball_path
    else
      # we are assuming it is not an archive, use original filename
      # this behaviour is due to ScriptFileFormula expectations
      # So I guess we should cp, but we mv, for this historic reason
      # HOWEVER if this breaks some expectation you had we *will* change the
      # behaviour, just open an issue at github
      # We also do this for jar files, as they are in fact zip files, but
      # we don't want to unzip them
      FileUtils.cp @tarball_path, basename_without_params
    end
  end

  private

  def curl(*args)
    args << '--connect-timeout' << '5' unless @mirrors.empty?
    super
  end

  def xzpath
    "#{HOMEBREW_PREFIX}/opt/xz/bin/xz"
  end

  def chdir
    entries=Dir['*']
    case entries.length
      when 0 then raise "Empty archive"
      when 1 then Dir.chdir entries.first rescue nil
    end
  end

  def basename_without_params
    # Strip any ?thing=wad out of .c?thing=wad style extensions
    File.basename(@url)[/[^?]+/]
  end

  def ext
    # GitHub uses odd URLs for zip files, so check for those
    rx=%r[https?://(www\.)?github\.com/.*/(zip|tar)ball/]
    if rx.match @url
      if $2 == 'zip'
        '.zip'
      else
        '.tgz'
      end
    else
      # Strip any ?thing=wad out of .c?thing=wad style extensions
      (Pathname.new(@url).extname)[/[^?]+/]
    end
  end
end

# Detect and download from Apache Mirror
class CurlApacheMirrorDownloadStrategy < CurlDownloadStrategy
  def _fetch
    mirrors = Utils::JSON.load(open("#{@url}&asjson=1").read)
    url = mirrors.fetch('preferred') + mirrors.fetch('path_info')

    ohai "Best Mirror #{url}"
    curl url, '-C', downloaded_size, '-o', @temporary_path
  rescue IndexError, Utils::JSON::Error
    raise "Couldn't determine mirror. Try again later."
  end
end

# Download via an HTTP POST.
# Query parameters on the URL are converted into POST parameters
class CurlPostDownloadStrategy < CurlDownloadStrategy
  def _fetch
    base_url,data = @url.split('?')
    curl base_url, '-d', data, '-C', downloaded_size, '-o', @temporary_path
  end
end

# Download from an SSL3-only host.
class CurlSSL3DownloadStrategy < CurlDownloadStrategy
  def _fetch
    curl @url, '-3', '-C', downloaded_size, '-o', @temporary_path
  end
end

# Use this strategy to download but not unzip a file.
# Useful for installing jars.
class NoUnzipCurlDownloadStrategy < CurlDownloadStrategy
  def stage
    FileUtils.cp @tarball_path, basename_without_params
  end
end

# This strategy is provided for use with sites that only provide HTTPS and
# also have a broken cert. Try not to need this, as we probably won't accept
# the formula.
class CurlUnsafeDownloadStrategy < CurlDownloadStrategy
  def _fetch
    curl @url, '--insecure', '-C', downloaded_size, '-o', @temporary_path
  end
end

# This strategy extracts our binary packages.
class CurlBottleDownloadStrategy < CurlDownloadStrategy
  def initialize name, package
    super
    @tarball_path = HOMEBREW_CACHE/"#{name}-#{package.version}#{ext}"
    mirror = ENV['HOMEBREW_SOURCEFORGE_MIRROR']
    @url = "#{@url}?use_mirror=#{mirror}" if mirror
  end
end

# This strategy extracts local binary packages.
class LocalBottleDownloadStrategy < CurlDownloadStrategy
  def initialize formula, local_bottle_path
    super formula.name, formula.active_spec
    @tarball_path = local_bottle_path
  end
end

class SubversionDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super
    @@svn ||= 'svn'

    if name.to_s.empty? || name == '__UNKNOWN__'
      raise NotImplementedError, "strategy requires a name parameter"
    else
      @co = Pathname.new("#{HOMEBREW_CACHE}/#{name}--svn")
    end

    @co = Pathname.new(@co.to_s + '-HEAD') if ARGV.build_head?
  end

  def cached_location
    @co
  end

  def fetch
    @url.sub!(/^svn\+/, '') if @url =~ %r[^svn\+http://]
    ohai "Checking out #{@url}"
    if @spec == :revision
      fetch_repo @co, @url, @ref
    elsif @spec == :revisions
      # nil is OK for main_revision, as fetch_repo will then get latest
      main_revision = @ref.delete :trunk
      fetch_repo @co, @url, main_revision, true

      get_externals do |external_name, external_url|
        fetch_repo @co+external_name, external_url, @ref[external_name], true
      end
    else
      fetch_repo @co, @url
    end
  end

  def stage
    quiet_safe_system @@svn, 'export', '--force', @co, Dir.pwd
  end

  def shell_quote str
    # Oh god escaping shell args.
    # See http://notetoself.vrensk.com/2008/08/escaping-single-quotes-in-ruby-harder-than-expected/
    str.gsub(/\\|'/) { |c| "\\#{c}" }
  end

  def get_externals
    `'#{shell_quote(svn)}' propget svn:externals '#{shell_quote(@url)}'`.chomp.each_line do |line|
      name, url = line.split(/\s+/)
      yield name, url
    end
  end

  def fetch_repo target, url, revision=nil, ignore_externals=false
    # Use "svn up" when the repository already exists locally.
    # This saves on bandwidth and will have a similar effect to verifying the
    # cache as it will make any changes to get the right revision.
    svncommand = target.exist? ? 'up' : 'checkout'
    args = [@@svn, svncommand]
    # SVN shipped with XCode 3.1.4 can't force a checkout.
    args << '--force' unless MacOS.version == :leopard and @@svn == '/usr/bin/svn'
    args << url if !target.exist?
    args << target
    args << '-r' << revision if revision
    args << '--ignore-externals' if ignore_externals
    quiet_safe_system(*args)
  end
end

# Require a newer version of Subversion than 1.4.x (Leopard-provided version)
class StrictSubversionDownloadStrategy < SubversionDownloadStrategy
  def find_svn
    exe = `svn -print-path`
    `#{exe} --version` =~ /version (\d+\.\d+(\.\d+)*)/
    svn_version = $1
    version_tuple=svn_version.split(".").collect {|v|Integer(v)}

    if version_tuple[0] == 1 and version_tuple[1] <= 4
      onoe "Detected Subversion (#{exe}, version #{svn_version}) is too old."
      puts "Subversion 1.4.x will not export externals correctly for this formula."
      puts "You must either `brew install subversion` or set HOMEBREW_SVN to the path"
      puts "of a newer svn binary."
    end
    return exe
  end
end

# Download from SVN servers with invalid or self-signed certs
class UnsafeSubversionDownloadStrategy < SubversionDownloadStrategy
  def fetch_repo target, url, revision=nil, ignore_externals=false
    # Use "svn up" when the repository already exists locally.
    # This saves on bandwidth and will have a similar effect to verifying the
    # cache as it will make any changes to get the right revision.
    svncommand = target.exist? ? 'up' : 'checkout'
    args = [@@svn, svncommand, '--non-interactive', '--trust-server-cert', '--force']
    args << url if !target.exist?
    args << target
    args << '-r' << revision if revision
    args << '--ignore-externals' if ignore_externals
    quiet_safe_system(*args)
  end
end

class GitDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super
    @@git ||= 'git'

    if name.to_s.empty? || name == '__UNKNOWN__'
      raise NotImplementedError, "strategy requires a name parameter"
    else
      @clone = Pathname.new("#{HOMEBREW_CACHE}/#{name}--git")
    end
  end

  def cached_location
    @clone
  end

  def fetch
    raise "You must: brew install git" unless which "git"

    ohai "Cloning #@url"

    if @clone.exist? && repo_valid?
      puts "Updating #@clone"
      Dir.chdir(@clone) do
        config_repo
        update_repo
        checkout
        reset
        update_submodules if submodules?
      end
    elsif @clone.exist?
      puts "Removing invalid .git repo from cache"
      FileUtils.rm_rf @clone
      clone_repo
    else
      clone_repo
    end
  end

  def stage
    dst = Dir.getwd
    Dir.chdir @clone do
      if @spec and @ref
        ohai "Checking out #@spec #@ref"
      else
        reset
      end
      # http://stackoverflow.com/questions/160608/how-to-do-a-git-export-like-svn-export
      safe_system @@git, 'checkout-index', '-a', '-f', "--prefix=#{dst}/"
      checkout_submodules(dst) if submodules?
    end
  end

  private

  def git_dir
    @clone.join(".git")
  end

  def has_ref?
    quiet_system @@git, '--git-dir', git_dir, 'rev-parse', '-q', '--verify', @ref
  end

  def support_depth?
    @spec != :revision and host_supports_depth?
  end

  def host_supports_depth?
    @url =~ %r{git://} or @url =~ %r{https://github.com/}
  end

  def repo_valid?
    quiet_system @@git, "--git-dir", git_dir, "status", "-s"
  end

  def submodules?
    @clone.join(".gitmodules").exist?
  end

  def clone_args
    args = %w{clone}
    args << '--depth' << '1' if support_depth?

    case @spec
    when :branch, :tag then args << '--branch' << @ref
    end

    args << @url << @clone
  end

  def refspec
    case @spec
    when :branch then "+refs/heads/#@ref:refs/remotes/origin/#@ref"
    when :tag    then "+refs/tags/#@ref:refs/tags/#@ref"
    else              "+refs/heads/master:refs/remotes/origin/master"
    end
  end

  def config_repo
    safe_system @@git, 'config', 'remote.origin.url', @url
    safe_system @@git, 'config', 'remote.origin.fetch', refspec
  end

  def update_repo
    unless @spec == :tag && has_ref?
      quiet_safe_system @@git, 'fetch', 'origin'
    end
  end

  def clone_repo
    safe_system @@git, *clone_args
    @clone.cd { update_submodules } if submodules?
  end

  def checkout_args
    ref = case @spec
          when :branch, :tag, :revision then @ref
          else `git symbolic-ref refs/remotes/origin/HEAD`.strip.split("/").last
          end

    args = %w{checkout -f}
    args << { :quiet_flag => '-q' }
    args << ref
  end

  def checkout
    nostdout { quiet_safe_system @@git, *checkout_args }
  end

  def reset_args
    ref = case @spec
          when :branch then "origin/#@ref"
          when :revision, :tag then @ref
          else "origin/HEAD"
          end

    args = %w{reset}
    args << { :quiet_flag => "-q" }
    args << "--hard" << ref
  end

  def reset
    quiet_safe_system @@git, *reset_args
  end

  def update_submodules
    safe_system @@git, 'submodule', 'update', '--init'
  end

  def checkout_submodules(dst)
    sub_cmd = %W{#@@git checkout-index -a -f --prefix=#{dst}/$path/}
    safe_system @@git, 'submodule', '--quiet', 'foreach', '--recursive', *sub_cmd
  end
end

class CVSDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super

    if name.to_s.empty? || name == '__UNKNOWN__'
      raise NotImplementedError, "strategy requires a name parameter"
    else
      @unique_token = "#{name}--cvs"
      @co = Pathname.new("#{HOMEBREW_CACHE}/#{@unique_token}")
    end
  end

  def cached_location; @co; end

  def fetch
    ohai "Checking out #{@url}"

    # URL of cvs cvs://:pserver:anoncvs@www.gccxml.org:/cvsroot/GCC_XML:gccxml
    # will become:
    # cvs -d :pserver:anoncvs@www.gccxml.org:/cvsroot/GCC_XML login
    # cvs -d :pserver:anoncvs@www.gccxml.org:/cvsroot/GCC_XML co gccxml
    mod, url = split_url(@url)

    unless @co.exist?
      Dir.chdir HOMEBREW_CACHE do
        safe_system '/usr/bin/cvs', '-d', url, 'login'
        safe_system '/usr/bin/cvs', '-d', url, 'checkout', '-d', @unique_token, mod
      end
    else
      puts "Updating #{@co}"
      Dir.chdir(@co) { safe_system '/usr/bin/cvs', 'up' }
    end
  end

  def stage
    FileUtils.cp_r Dir[@co+"{.}"], Dir.pwd

    require 'find'
    Find.find(Dir.pwd) do |path|
      if FileTest.directory?(path) && File.basename(path) == "CVS"
        Find.prune
        FileUtil.rm_r path, :force => true
      end
    end
  end

  private

  def split_url(in_url)
    parts=in_url.sub(%r[^cvs://], '').split(/:/)
    mod=parts.pop
    url=parts.join(':')
    [ mod, url ]
  end
end

class MercurialDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super

    if name.to_s.empty? || name == '__UNKNOWN__'
      raise NotImplementedError, "strategy requires a name parameter"
    else
      @clone = Pathname.new("#{HOMEBREW_CACHE}/#{name}--hg")
    end
  end

  def cached_location; @clone; end

  def hgpath
    # #{HOMEBREW_PREFIX}/share/python/hg is deprecated, but we levae it in for a while
    @path ||= %W[
      #{which("hg")}
      #{HOMEBREW_PREFIX}/bin/hg
      #{Formula.factory('mercurial').opt_prefix}/bin/hg
      #{HOMEBREW_PREFIX}/share/python/hg
      ].find { |p| File.executable? p }
  end

  def fetch
    raise "You must: brew install mercurial" unless hgpath

    ohai "Cloning #{@url}"

    unless @clone.exist?
      url=@url.sub(%r[^hg://], '')
      safe_system hgpath, 'clone', url, @clone
    else
      puts "Updating #{@clone}"
      Dir.chdir(@clone) do
        safe_system hgpath, 'pull'
        safe_system hgpath, 'update'
      end
    end
  end

  def stage
    dst=Dir.getwd
    Dir.chdir @clone do
      if @spec and @ref
        ohai "Checking out #{@spec} #{@ref}"
        safe_system hgpath, 'archive', '--subrepos', '-y', '-r', @ref, '-t', 'files', dst
      else
        safe_system hgpath, 'archive', '--subrepos', '-y', '-t', 'files', dst
      end
    end
  end
end

class BazaarDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super

    if name.to_s.empty? || name == '__UNKNOWN__'
      raise NotImplementedError, "strategy requires a name parameter"
    else
      @clone = Pathname.new("#{HOMEBREW_CACHE}/#{name}--bzr")
    end
  end

  def cached_location; @clone; end

  def bzrpath
    @path ||= %W[
      #{which("bzr")}
      #{HOMEBREW_PREFIX}/bin/bzr
      ].find { |p| File.executable? p }
  end

  def fetch
    raise "You must: brew install bazaar" unless bzrpath

    ohai "Cloning #{@url}"
    unless @clone.exist?
      url=@url.sub(%r[^bzr://], '')
      # 'lightweight' means history-less
      safe_system bzrpath, 'checkout', '--lightweight', url, @clone
    else
      puts "Updating #{@clone}"
      Dir.chdir(@clone) { safe_system bzrpath, 'update' }
    end
  end

  def stage
    # FIXME: The export command doesn't work on checkouts
    # See https://bugs.launchpad.net/bzr/+bug/897511
    FileUtils.cp_r Dir[@clone+"{.}"], Dir.pwd
    FileUtils.rm_r Dir[Dir.pwd+"/.bzr"]

    #dst=Dir.getwd
    #Dir.chdir @clone do
    #  if @spec and @ref
    #    ohai "Checking out #{@spec} #{@ref}"
    #    Dir.chdir @clone do
    #      safe_system bzrpath, 'export', '-r', @ref, dst
    #    end
    #  else
    #    safe_system bzrpath, 'export', dst
    #  end
    #end
  end
end

class FossilDownloadStrategy < AbstractDownloadStrategy
  def initialize name, package
    super
    if name.to_s.empty? || name == '__UNKNOWN__'
      raise NotImplementedError, "strategy requires a name parameter"
    else
      @clone = Pathname.new("#{HOMEBREW_CACHE}/#{name}--fossil")
    end
  end

  def cached_location; @clone; end

  def fossilpath
    @path ||= %W[
      #{which("fossil")}
      #{HOMEBREW_PREFIX}/bin/fossil
      ].find { |p| File.executable? p }
  end

  def fetch
    raise "You must: brew install fossil" unless fossilpath

    ohai "Cloning #{@url}"
    unless @clone.exist?
      url=@url.sub(%r[^fossil://], '')
      safe_system fossilpath, 'clone', url, @clone
    else
      puts "Updating #{@clone}"
      safe_system fossilpath, 'pull', '-R', @clone
    end
  end

  def stage
    # TODO: The 'open' and 'checkout' commands are very noisy and have no '-q' option.
    safe_system fossilpath, 'open', @clone
    if @spec and @ref
      ohai "Checking out #{@spec} #{@ref}"
      safe_system fossilpath, 'checkout', @ref
    end
  end
end

class DownloadStrategyDetector
  def self.detect(url, strategy=nil)
    if strategy.is_a? Class and strategy.ancestors.include? AbstractDownloadStrategy
      strategy
    elsif strategy.is_a? Symbol
      detect_from_symbol(strategy)
    else
      detect_from_url(url)
    end
  end

  def self.detect_from_url(url)
    case url
      # We use a special URL pattern for cvs
    when %r[^cvs://] then CVSDownloadStrategy
      # Standard URLs
    when %r[^bzr://] then BazaarDownloadStrategy
    when %r[^git://] then GitDownloadStrategy
    when %r[^https?://.+\.git$] then GitDownloadStrategy
    when %r[^hg://] then MercurialDownloadStrategy
    when %r[^svn://] then SubversionDownloadStrategy
    when %r[^svn\+http://] then SubversionDownloadStrategy
    when %r[^fossil://] then FossilDownloadStrategy
      # Some well-known source hosts
    when %r[^https?://(.+?\.)?googlecode\.com/hg] then MercurialDownloadStrategy
    when %r[^https?://(.+?\.)?googlecode\.com/svn] then SubversionDownloadStrategy
    when %r[^https?://(.+?\.)?sourceforge\.net/svnroot/] then SubversionDownloadStrategy
    when %r[^https?://(.+?\.)?sourceforge\.net/hgweb/] then MercurialDownloadStrategy
    when %r[^http://svn.apache.org/repos/] then SubversionDownloadStrategy
    when %r[^http://www.apache.org/dyn/closer.cgi] then CurlApacheMirrorDownloadStrategy
      # Common URL patterns
    when %r[^https?://svn\.] then SubversionDownloadStrategy
    when bottle_native_regex, bottle_regex
      CurlBottleDownloadStrategy
      # Otherwise just try to download
    else CurlDownloadStrategy
    end
  end

  def self.detect_from_symbol(symbol)
    case symbol
    when :bzr then BazaarDownloadStrategy
    when :curl then CurlDownloadStrategy
    when :cvs then CVSDownloadStrategy
    when :git then GitDownloadStrategy
    when :hg then MercurialDownloadStrategy
    when :nounzip then NoUnzipCurlDownloadStrategy
    when :post then CurlPostDownloadStrategy
    when :ssl3 then CurlSSL3DownloadStrategy
    when :svn then SubversionDownloadStrategy
    else
      raise "Unknown download strategy #{strategy} was requested."
    end
  end
end
