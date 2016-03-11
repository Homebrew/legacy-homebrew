require "utils/json"

class AbstractDownloadStrategy
  include FileUtils

  attr_reader :meta, :name, :version, :resource

  def initialize(name, resource)
    @name = name
    @resource = resource
    @url = resource.url
    @version = resource.version
    @meta = resource.specs
  end

  # Download and cache the resource as {#cached_location}.
  def fetch
  end

  # Unpack {#cached_location} into the current working directory.
  def stage
  end

  # @!attribute [r] cached_location
  # The path to the cached file or directory associated with the resource.
  def cached_location
  end

  # @!attribute [r]
  # return most recent modified time for all files in the current working directory after stage.
  def source_modified_time
    Pathname.pwd.to_enum(:find).select(&:file?).map(&:mtime).max
  end

  # Remove {#cached_location} and any other files associated with the resource
  # from the cache.
  def clear_cache
    rm_rf(cached_location)
  end

  def expand_safe_system_args(args)
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
    args.insert(2, "-q") unless ARGV.verbose?
    args
  end

  def quiet_safe_system(*args)
    safe_system(*expand_safe_system_args(args))
  end

  private

  def xzpath
    "#{HOMEBREW_PREFIX}/opt/xz/bin/xz"
  end

  def lzippath
    "#{HOMEBREW_PREFIX}/opt/lzip/bin/lzip"
  end

  def lhapath
    "#{HOMEBREW_PREFIX}/opt/lha/bin/lha"
  end

  def cvspath
    @cvspath ||= %W[
      /usr/bin/cvs
      #{HOMEBREW_PREFIX}/bin/cvs
      #{HOMEBREW_PREFIX}/opt/cvs/bin/cvs
      #{which("cvs")}
    ].find { |p| File.executable? p }
  end

  def hgpath
    @hgpath ||= %W[
      #{which("hg")}
      #{HOMEBREW_PREFIX}/bin/hg
      #{HOMEBREW_PREFIX}/opt/mercurial/bin/hg
    ].find { |p| File.executable? p }
  end

  def bzrpath
    @bzrpath ||= %W[
      #{which("bzr")}
      #{HOMEBREW_PREFIX}/bin/bzr
      #{HOMEBREW_PREFIX}/opt/bazaar/bin/bzr
    ].find { |p| File.executable? p }
  end

  def fossilpath
    @fossilpath ||= %W[
      #{which("fossil")}
      #{HOMEBREW_PREFIX}/bin/fossil
      #{HOMEBREW_PREFIX}/opt/fossil/bin/fossil
    ].find { |p| File.executable? p }
  end
end

class VCSDownloadStrategy < AbstractDownloadStrategy
  REF_TYPES = [:tag, :branch, :revisions, :revision].freeze

  def initialize(name, resource)
    super
    @ref_type, @ref = extract_ref(meta)
    @revision = meta[:revision]
    @clone = HOMEBREW_CACHE.join(cache_filename)
  end

  def fetch
    ohai "Cloning #{@url}"

    if cached_location.exist? && repo_valid?
      puts "Updating #{cached_location}"
      update
    elsif cached_location.exist?
      puts "Removing invalid repository from cache"
      clear_cache
      clone_repo
    else
      clone_repo
    end

    if @ref_type == :tag && @revision && current_revision
      unless current_revision == @revision
        raise <<-EOS.undent
          #{@ref} tag should be #{@revision}
          but is actually #{current_revision}
        EOS
      end
    end
  end

  def cached_location
    @clone
  end

  def head?
    version.head?
  end

  private

  def cache_tag
    "__UNKNOWN__"
  end

  def cache_filename
    "#{name}--#{cache_tag}"
  end

  def repo_valid?
    true
  end

  def clone_repo
  end

  def update
  end

  def current_revision
  end

  def extract_ref(specs)
    key = REF_TYPES.find { |type| specs.key?(type) }
    [key, specs[key]]
  end
end

class AbstractFileDownloadStrategy < AbstractDownloadStrategy
  def stage
    case cached_location.compression_type
    when :zip
      with_system_path { quiet_safe_system "unzip", { :quiet_flag => "-qq" }, cached_location }
      chdir
    when :gzip_only
      with_system_path { buffered_write("gunzip") }
    when :bzip2_only
      with_system_path { buffered_write("bunzip2") }
    when :gzip, :bzip2, :compress, :tar
      # Assume these are also tarred
      tar_flags = (ARGV.verbose? && ENV["TRAVIS"].nil?) ? "xvf" : "xf"
      with_system_path { safe_system "tar", tar_flags, cached_location }
      chdir
    when :xz
      with_system_path { pipe_to_tar(xzpath) }
      chdir
    when :lzip
      with_system_path { pipe_to_tar(lzippath) }
      chdir
    when :lha
      safe_system lhapath, "x", cached_location
    when :xar
      safe_system "/usr/bin/xar", "-xf", cached_location
    when :rar
      quiet_safe_system "unrar", "x", { :quiet_flag => "-inul" }, cached_location
    when :p7zip
      safe_system "7zr", "x", cached_location
    else
      cp cached_location, basename_without_params
    end
  end

  private

  def chdir
    entries = Dir["*"]
    case entries.length
    when 0 then raise "Empty archive"
    when 1 then Dir.chdir entries.first rescue nil
    end
  end

  def pipe_to_tar(tool)
    Utils.popen_read(tool, "-dc", cached_location.to_s) do |rd|
      Utils.popen_write("tar", "xf", "-") do |wr|
        buf = ""
        wr.write(buf) while rd.read(16384, buf)
      end
    end
  end

  # gunzip and bunzip2 write the output file in the same directory as the input
  # file regardless of the current working directory, so we need to write it to
  # the correct location ourselves.
  def buffered_write(tool)
    target = File.basename(basename_without_params, cached_location.extname)

    Utils.popen_read(tool, "-f", cached_location.to_s, "-c") do |pipe|
      File.open(target, "wb") do |f|
        buf = ""
        f.write(buf) while pipe.read(16384, buf)
      end
    end
  end

  def basename_without_params
    # Strip any ?thing=wad out of .c?thing=wad style extensions
    File.basename(@url)[/[^?]+/]
  end

  def ext
    # We need a Pathname because we've monkeypatched extname to support double
    # extensions (e.g. tar.gz).
    # We can't use basename_without_params, because given a URL like
    #   https://example.com/download.php?file=foo-1.0.tar.gz
    # the extension we want is ".tar.gz", not ".php".
    Pathname.new(@url).extname[/[^?]+/]
  end
end

class CurlDownloadStrategy < AbstractFileDownloadStrategy
  attr_reader :mirrors, :tarball_path, :temporary_path

  def initialize(name, resource)
    super
    @mirrors = resource.mirrors.dup
    @tarball_path = HOMEBREW_CACHE.join("#{name}-#{version}#{ext}")
    @temporary_path = Pathname.new("#{cached_location}.incomplete")
  end

  def fetch
    ohai "Downloading #{@url}"

    unless cached_location.exist?
      urls = actual_urls
      unless urls.empty?
        ohai "Downloading from #{urls.last}"
        if !ENV["HOMEBREW_NO_INSECURE_REDIRECT"].nil? && @url.start_with?("https://") &&
           urls.any? { |u| !u.start_with? "https://" }
          puts "HTTPS to HTTP redirect detected & HOMEBREW_NO_INSECURE_REDIRECT is set."
          raise CurlDownloadStrategyError.new(@url)
        end
        @url = urls.last
      end

      had_incomplete_download = temporary_path.exist?
      begin
        _fetch
      rescue ErrorDuringExecution
        # 33 == range not supported
        # try wiping the incomplete download and retrying once
        if $?.exitstatus == 33 && had_incomplete_download
          ohai "Trying a full download"
          temporary_path.unlink
          had_incomplete_download = false
          retry
        else
          raise CurlDownloadStrategyError.new(@url)
        end
      end
      ignore_interrupts { temporary_path.rename(cached_location) }
    else
      puts "Already downloaded: #{cached_location}"
    end
  rescue CurlDownloadStrategyError
    raise if mirrors.empty?
    puts "Trying a mirror..."
    @url = mirrors.shift
    retry
  end

  def cached_location
    tarball_path
  end

  def clear_cache
    super
    rm_rf(temporary_path)
  end

  private

  # Private method, can be overridden if needed.
  def _fetch
    curl @url, "-C", downloaded_size, "-o", temporary_path
  end

  # Curl options to be always passed to curl,
  # with raw head calls (`curl -I`) or with actual `fetch`.
  def _curl_opts
    copts = []
    copts << "--user" << meta.fetch(:user) if meta.key?(:user)
    copts
  end

  def actual_urls
    urls = []
    curl_args = _curl_opts << "-I" << "-L" << @url
    Utils.popen_read("curl", *curl_args).scan(/^Location: (.+)$/).map do |m|
      urls << URI.join(urls.last || @url, m.first.chomp).to_s
    end
    urls
  end

  def downloaded_size
    temporary_path.size? || 0
  end

  def curl(*args)
    args.concat _curl_opts
    args << "--connect-timeout" << "5" unless mirrors.empty?
    super
  end
end

# Detect and download from Apache Mirror
class CurlApacheMirrorDownloadStrategy < CurlDownloadStrategy
  def apache_mirrors
    rd, wr = IO.pipe
    buf = ""

    pid = fork do
      ENV.delete "HOMEBREW_CURL_VERBOSE"
      rd.close
      $stdout.reopen(wr)
      $stderr.reopen(wr)
      curl "#{@url}&asjson=1"
    end
    wr.close

    rd.readline if ARGV.verbose? # Remove Homebrew output
    buf << rd.read until rd.eof?
    rd.close
    Process.wait(pid)
    buf
  end

  def _fetch
    return super if @tried_apache_mirror
    @tried_apache_mirror = true

    mirrors = Utils::JSON.load(apache_mirrors)
    path_info = mirrors.fetch("path_info")
    @url = mirrors.fetch("preferred") + path_info
    @mirrors |= %W[https://archive.apache.org/dist/#{path_info}]

    ohai "Best Mirror #{@url}"
    super
  rescue IndexError, Utils::JSON::Error
    raise CurlDownloadStrategyError, "Couldn't determine mirror, try again later."
  end
end

# Download via an HTTP POST.
# Query parameters on the URL are converted into POST parameters
class CurlPostDownloadStrategy < CurlDownloadStrategy
  def _fetch
    base_url, data = @url.split("?")
    curl base_url, "-d", data, "-C", downloaded_size, "-o", temporary_path
  end
end

# Use this strategy to download but not unzip a file.
# Useful for installing jars.
class NoUnzipCurlDownloadStrategy < CurlDownloadStrategy
  def stage
    cp cached_location, basename_without_params
  end
end

# This strategy extracts our binary packages.
class CurlBottleDownloadStrategy < CurlDownloadStrategy
  def stage
    ohai "Pouring #{cached_location.basename}"
    super
  end
end

# This strategy extracts local binary packages.
class LocalBottleDownloadStrategy < AbstractFileDownloadStrategy
  attr_reader :cached_location

  def initialize(path)
    @cached_location = path
  end

  def stage
    ohai "Pouring #{cached_location.basename}"
    super
  end
end

# S3DownloadStrategy downloads tarballs from AWS S3.
# To use it, add ":using => S3DownloadStrategy" to the URL section of your
# formula.  This download strategy uses AWS access tokens (in the
# environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)
# to sign the request.  This strategy is good in a corporate setting,
# because it lets you use a private S3 bucket as a repo for internal
# distribution.  (It will work for public buckets as well.)
class S3DownloadStrategy < CurlDownloadStrategy
  def _fetch
    # Put the aws gem requirement here (vs top of file) so it's only
    # a dependency of S3 users, not all Homebrew users
    require "rubygems"
    begin
      require "aws-sdk-v1"
    rescue LoadError
      onoe "Install the aws-sdk gem into the gem repo used by brew."
      raise
    end

    if @url !~ %r{^https?://([^.].*)\.s3\.amazonaws\.com/(.+)$}
      raise "Bad S3 URL: " + @url
    end
    bucket = $1
    key = $2

    obj = AWS::S3.new.buckets[bucket].objects[key]
    begin
      s3url = obj.url_for(:get)
    rescue AWS::Errors::MissingCredentialsError
      ohai "AWS credentials missing, trying public URL instead."
      s3url = obj.public_url
    end

    curl s3url, "-C", downloaded_size, "-o", temporary_path
  end
end

class SubversionDownloadStrategy < VCSDownloadStrategy
  def initialize(name, resource)
    super
    @url = @url.sub("svn+http://", "")
  end

  def fetch
    clear_cache unless @url.chomp("/") == repo_url || quiet_system("svn", "switch", @url, cached_location)
    super
  end

  def stage
    super
    quiet_safe_system "svn", "export", "--force", cached_location, Dir.pwd
  end

  private

  def repo_url
    Utils.popen_read("svn", "info", cached_location.to_s).strip[/^URL: (.+)$/, 1]
  end

  def get_externals
    Utils.popen_read("svn", "propget", "svn:externals", @url).chomp.each_line do |line|
      name, url = line.split(/\s+/)
      yield name, url
    end
  end

  def fetch_repo(target, url, revision = nil, ignore_externals = false)
    # Use "svn up" when the repository already exists locally.
    # This saves on bandwidth and will have a similar effect to verifying the
    # cache as it will make any changes to get the right revision.
    svncommand = target.directory? ? "up" : "checkout"
    args = ["svn", svncommand]
    args << url unless target.directory?
    args << target
    if revision
      ohai "Checking out #{@ref}"
      args << "-r" << revision
    end
    args << "--ignore-externals" if ignore_externals
    quiet_safe_system(*args)
  end

  def cache_tag
    head? ? "svn-HEAD" : "svn"
  end

  def repo_valid?
    cached_location.join(".svn").directory?
  end

  def clone_repo
    case @ref_type
    when :revision
      fetch_repo cached_location, @url, @ref
    when :revisions
      # nil is OK for main_revision, as fetch_repo will then get latest
      main_revision = @ref[:trunk]
      fetch_repo cached_location, @url, main_revision, true

      get_externals do |external_name, external_url|
        fetch_repo cached_location+external_name, external_url, @ref[external_name], true
      end
    else
      fetch_repo cached_location, @url
    end
  end
  alias_method :update, :clone_repo
end

class GitDownloadStrategy < VCSDownloadStrategy
  SHALLOW_CLONE_WHITELIST = [
    %r{git://},
    %r{https://github\.com},
    %r{http://git\.sv\.gnu\.org},
    %r{http://llvm\.org}
  ]

  def initialize(name, resource)
    super
    @ref_type ||= :branch
    @ref ||= "master"
    @shallow = meta.fetch(:shallow) { true }
  end

  def stage
    super
    cp_r File.join(cached_location, "."), Dir.pwd
  end

  def source_modified_time
    Time.parse Utils.popen_read("git", "--git-dir", git_dir, "show", "-s", "--format=%cD")
  end

  private

  def cache_tag
    "git"
  end

  def cache_version
    0
  end

  def update
    cached_location.cd do
      config_repo
      update_repo
      checkout
      reset
      update_submodules if submodules?
    end
  end

  def shallow_clone?
    @shallow && support_depth?
  end

  def is_shallow_clone?
    git_dir.join("shallow").exist?
  end

  def support_depth?
    @ref_type != :revision && SHALLOW_CLONE_WHITELIST.any? { |rx| rx === @url }
  end

  def git_dir
    cached_location.join(".git")
  end

  def has_ref?
    quiet_system "git", "--git-dir", git_dir, "rev-parse", "-q", "--verify", "#{@ref}^{commit}"
  end

  def current_revision
    Utils.popen_read("git", "--git-dir", git_dir, "rev-parse", "-q", "--verify", "HEAD").strip
  end

  def repo_valid?
    quiet_system "git", "--git-dir", git_dir, "status", "-s"
  end

  def submodules?
    cached_location.join(".gitmodules").exist?
  end

  def clone_args
    args = %w[clone]
    args << "--depth" << "1" if shallow_clone?

    case @ref_type
    when :branch, :tag then args << "--branch" << @ref
    end

    args << @url << cached_location
  end

  def refspec
    case @ref_type
    when :branch then "+refs/heads/#{@ref}:refs/remotes/origin/#{@ref}"
    when :tag    then "+refs/tags/#{@ref}:refs/tags/#{@ref}"
    else              "+refs/heads/master:refs/remotes/origin/master"
    end
  end

  def config_repo
    safe_system "git", "config", "remote.origin.url", @url
    safe_system "git", "config", "remote.origin.fetch", refspec
  end

  def update_repo
    if @ref_type == :branch || !has_ref?
      if !shallow_clone? && is_shallow_clone?
        quiet_safe_system "git", "fetch", "origin", "--unshallow"
      else
        quiet_safe_system "git", "fetch", "origin"
      end
    end
  end

  def clone_repo
    safe_system "git", *clone_args
    cached_location.cd do
      safe_system "git", "config", "homebrew.cacheversion", cache_version
      checkout
      update_submodules if submodules?
    end
  end

  def checkout
    ohai "Checking out #{@ref_type} #{@ref}" if @ref_type && @ref
    quiet_safe_system "git", "checkout", "-f", @ref, "--"
  end

  def reset_args
    ref = case @ref_type
          when :branch then "origin/#{@ref}"
          when :revision, :tag then @ref
          end

    %W[reset --hard #{ref}]
  end

  def reset
    quiet_safe_system "git", *reset_args
  end

  def update_submodules
    quiet_safe_system "git", "submodule", "foreach", "--recursive", "git submodule sync"
    quiet_safe_system "git", "submodule", "update", "--init", "--recursive"
  end
end

class CVSDownloadStrategy < VCSDownloadStrategy
  def initialize(name, resource)
    super
    @url = @url.sub(%r{^cvs://}, "")

    if meta.key?(:module)
      @module = meta.fetch(:module)
    elsif @url !~ %r{:[^/]+$}
      @module = name
    else
      @module, @url = split_url(@url)
    end
  end

  def stage
    cp_r File.join(cached_location, "."), Dir.pwd
  end

  private

  def cache_tag
    "cvs"
  end

  def repo_valid?
    cached_location.join("CVS").directory?
  end

  def clone_repo
    HOMEBREW_CACHE.cd do
      # Login is only needed (and allowed) with pserver; skip for anoncvs.
      quiet_safe_system cvspath, { :quiet_flag => "-Q" }, "-d", @url, "login" if @url.include? "pserver"
      quiet_safe_system cvspath, { :quiet_flag => "-Q" }, "-d", @url, "checkout", "-d", cache_filename, @module
    end
  end

  def update
    cached_location.cd { quiet_safe_system cvspath, { :quiet_flag => "-Q" }, "up" }
  end

  def split_url(in_url)
    parts = in_url.split(/:/)
    mod=parts.pop
    url=parts.join(":")
    [mod, url]
  end
end

class MercurialDownloadStrategy < VCSDownloadStrategy
  def initialize(name, resource)
    super
    @url = @url.sub(%r{^hg://}, "")
  end

  def stage
    super

    dst = Dir.getwd
    cached_location.cd do
      if @ref_type && @ref
        ohai "Checking out #{@ref_type} #{@ref}" if @ref_type && @ref
        safe_system hgpath, "archive", "--subrepos", "-y", "-r", @ref, "-t", "files", dst
      else
        safe_system hgpath, "archive", "--subrepos", "-y", "-t", "files", dst
      end
    end
  end

  private

  def cache_tag
    "hg"
  end

  def repo_valid?
    cached_location.join(".hg").directory?
  end

  def clone_repo
    safe_system hgpath, "clone", @url, cached_location
  end

  def update
    cached_location.cd { quiet_safe_system hgpath, "pull", "--update" }
  end
end

class BazaarDownloadStrategy < VCSDownloadStrategy
  def initialize(name, resource)
    super
    @url = @url.sub(%r{^bzr://}, "")
  end

  def stage
    # The export command doesn't work on checkouts
    # See https://bugs.launchpad.net/bzr/+bug/897511
    cp_r File.join(cached_location, "."), Dir.pwd
    rm_r ".bzr"
  end

  private

  def cache_tag
    "bzr"
  end

  def repo_valid?
    cached_location.join(".bzr").directory?
  end

  def clone_repo
    # "lightweight" means history-less
    safe_system bzrpath, "checkout", "--lightweight", @url, cached_location
  end

  def update
    cached_location.cd { quiet_safe_system bzrpath, "update" }
  end
end

class FossilDownloadStrategy < VCSDownloadStrategy
  def initialize(name, resource)
    super
    @url = @url.sub(%r{^fossil://}, "")
  end

  def stage
    super
    args = [fossilpath, "open", cached_location]
    args << @ref if @ref_type && @ref
    safe_system(*args)
  end

  private

  def cache_tag
    "fossil"
  end

  def clone_repo
    safe_system fossilpath, "clone", @url, cached_location
  end

  def update
    safe_system fossilpath, "pull", "-R", cached_location
  end
end

class DownloadStrategyDetector
  def self.detect(url, strategy = nil)
    if strategy.nil?
      detect_from_url(url)
    elsif Class === strategy && strategy < AbstractDownloadStrategy
      strategy
    elsif Symbol === strategy
      detect_from_symbol(strategy)
    else
      raise TypeError,
        "Unknown download strategy specification #{strategy.inspect}"
    end
  end

  def self.detect_from_url(url)
    case url
    when %r{^https?://.+\.git$}, %r{^git://}
      GitDownloadStrategy
    when %r{^https?://www\.apache\.org/dyn/closer\.cgi}, %r{^https?://www\.apache\.org/dyn/closer\.lua}
      CurlApacheMirrorDownloadStrategy
    when %r{^https?://(.+?\.)?googlecode\.com/svn}, %r{^https?://svn\.}, %r{^svn://}, %r{^https?://(.+?\.)?sourceforge\.net/svnroot/}
      SubversionDownloadStrategy
    when %r{^cvs://}
      CVSDownloadStrategy
    when %r{^https?://(.+?\.)?googlecode\.com/hg}
      MercurialDownloadStrategy
    when %r{^hg://}
      MercurialDownloadStrategy
    when %r{^bzr://}
      BazaarDownloadStrategy
    when %r{^fossil://}
      FossilDownloadStrategy
    when %r{^http://svn\.apache\.org/repos/}, %r{^svn\+http://}
      SubversionDownloadStrategy
    when %r{^https?://(.+?\.)?sourceforge\.net/hgweb/}
      MercurialDownloadStrategy
    else
      CurlDownloadStrategy
    end
  end

  def self.detect_from_symbol(symbol)
    case symbol
    when :hg      then MercurialDownloadStrategy
    when :nounzip then NoUnzipCurlDownloadStrategy
    when :git     then GitDownloadStrategy
    when :bzr     then BazaarDownloadStrategy
    when :svn     then SubversionDownloadStrategy
    when :curl    then CurlDownloadStrategy
    when :ssl3    then CurlSSL3DownloadStrategy
    when :cvs     then CVSDownloadStrategy
    when :post    then CurlPostDownloadStrategy
    when :fossil  then FossilDownloadStrategy
    else
      raise "Unknown download strategy #{strategy} was requested."
    end
  end
end
