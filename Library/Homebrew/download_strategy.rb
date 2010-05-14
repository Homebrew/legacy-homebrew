class AbstractDownloadStrategy
  def initialize url, name, version, specs
    @url=url
    case specs when Hash
      @spec = specs.keys.first # only use first spec
      @ref = specs.values.first
    end
    @unique_token="#{name}-#{version}" unless name.to_s.empty? or name == '__UNKNOWN__'
  end

  def expand_safe_system_args args
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
    return args
  end

  def quiet_safe_system *args
    safe_system *expand_safe_system_args(args)
  end
end

class CurlDownloadStrategy <AbstractDownloadStrategy
  attr_reader :tarball_path
  
  def initialize url, name, version, specs
    super
    if @unique_token
      @tarball_path=HOMEBREW_CACHE+(@unique_token+ext)
    else
      @tarball_path=HOMEBREW_CACHE+File.basename(@url)
    end
  end
  
  def cached_location
    @tarball_path
  end

  def fetch
    ohai "Downloading #{@url}"
    unless @tarball_path.exist?
      begin
        curl @url, '-o', @tarball_path
      rescue Exception
        ignore_interrupts { @tarball_path.unlink if @tarball_path.exist? }
        raise
      end
    else
      puts "File already downloaded and cached to #{HOMEBREW_CACHE}"
    end
    return @tarball_path # thus performs checksum verification
  end

  def stage
    if @tarball_path.extname == '.jar'
      magic_bytes = nil
    else
      # get the first four bytes
      File.open(@tarball_path) { |f| magic_bytes = f.read(4) }
    end

    # magic numbers stolen from /usr/share/file/magic/
    case magic_bytes
    when /^PK\003\004/ # .zip archive
      quiet_safe_system '/usr/bin/unzip', {:quiet_flag => '-qq'}, @tarball_path
      chdir
    when /^\037\213/, /^BZh/, /^\037\235/  # gzip/bz2/compress compressed
      # TODO check if it's really a tar archive
      safe_system '/usr/bin/tar', 'xf', @tarball_path
      chdir
    when 'Rar!'
      quiet_safe_system 'unrar', 'x', {:quiet_flag => '-inul'}, @tarball_path
    else
      # we are assuming it is not an archive, use original filename
      # this behaviour is due to ScriptFileFormula expectations
      # So I guess we should cp, but we mv, for this historic reason
      # HOWEVER if this breaks some expectation you had we *will* change the
      # behaviour, just open an issue at github
      # We also do this for jar files, as they are in fact zip files, but
      # we don't want to unzip them
      FileUtils.mv @tarball_path, File.basename(@url)
    end
  end

private
  def chdir
    entries=Dir['*']
    case entries.length
      when 0 then raise "Empty archive"
      when 1 then Dir.chdir entries.first rescue nil
    end
  end

  def ext
    # GitHub uses odd URLs for zip files, so check for those
    rx=%r[http://(www\.)?github\.com/.*/(zip|tar)ball/]
    if rx.match @url
      if $2 == 'zip'
        '.zip'
      else
        '.tgz'
      end
    else
      Pathname.new(@url).extname
    end
  end
end

# Use this strategy to download but not unzip a file.
# Useful for installing jars.
class NoUnzipCurlDownloadStrategy <CurlDownloadStrategy
  def stage
    FileUtils.mv @tarball_path, File.basename(@url)
  end
end

class SubversionDownloadStrategy <AbstractDownloadStrategy
  def initialize url, name, version, specs
    super
    @co=HOMEBREW_CACHE+@unique_token
  end

  def cached_location
    @co
  end

  def fetch
    ohai "Checking out #{@url}"
    unless @co.exist?
      quiet_safe_system svn, 'checkout', @url, @co
    else
      puts "Updating #{@co}"
      quiet_safe_system svn, 'up', @co
    end
  end

  def stage
    # Force the export, since the target directory will already exist
    args = [svn, 'export', '--force', @co, Dir.pwd]
    args << '-r' << @ref if @spec == :revision and @ref
    quiet_safe_system *args
  end

  # Override this method in a DownloadStrategy to force the use of a non-
  # sysetm svn binary. mplayer.rb uses this to require a svn that
  # understands externals.
  def svn
    '/usr/bin/svn'
  end
end

class GitDownloadStrategy <AbstractDownloadStrategy
  def initialize url, name, version, specs
    super
    @clone=HOMEBREW_CACHE+@unique_token
  end

  def cached_location
    @clone
  end

  def fetch
    ohai "Cloning #{@url}"
    unless @clone.exist?
      safe_system 'git', 'clone', @url, @clone # indeed, leave it verbose
    else
      puts "Updating #{@clone}"
      Dir.chdir(@clone) { quiet_safe_system 'git', 'fetch', @url }
    end
  end

  def stage
    dst = Dir.getwd
    Dir.chdir @clone do
      if @spec and @ref
        ohai "Checking out #{@spec} #{@ref}"
        case @spec
        when :branch
          nostdout { quiet_safe_system 'git', 'checkout', "origin/#{@ref}" }
        when :tag
          nostdout { quiet_safe_system 'git', 'checkout', @ref }
        end
      end
      # http://stackoverflow.com/questions/160608/how-to-do-a-git-export-like-svn-export
      safe_system 'git', 'checkout-index', '-a', '-f', "--prefix=#{dst}/"
      # check for submodules
      if File.exist?('.gitmodules')
        safe_system 'git', 'submodule', 'init'
        safe_system 'git', 'submodule', 'update'
        sub_cmd = "git checkout-index -a -f \"--prefix=#{dst}/$path/\""
        safe_system 'git', 'submodule', '--quiet', 'foreach', '--recursive', sub_cmd
      end
    end
  end
end

class CVSDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Checking out #{@url}"
    @co=HOMEBREW_CACHE+@unique_token

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
      d = HOMEBREW_CACHE+@unique_token
      puts "Updating #{d}"
      Dir.chdir(d) { safe_system '/usr/bin/cvs', 'up' }
    end
  end

  def stage
    FileUtils.cp_r(Dir[HOMEBREW_CACHE+@unique_token+"*"], Dir.pwd)

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

class MercurialDownloadStrategy <AbstractDownloadStrategy
  def fetch
    raise "You must install mercurial, there are two options:\n\n"+
          "    brew install pip && pip install mercurial\n"+
          "    easy_install mercurial\n\n"+
          "Homebrew recommends pip over the OS X provided easy_install." \
          unless system "/usr/bin/which hg"

    ohai "Cloning #{@url}"
    @clone=HOMEBREW_CACHE+@unique_token

    url=@url.sub(%r[^hg://], '')

    unless @clone.exist?
      safe_system 'hg', 'clone', url, @clone
    else
      puts "Updating #{@clone}"
      Dir.chdir(@clone) { safe_system 'hg', 'update' }
    end
  end

  def stage
    dst=Dir.getwd
    Dir.chdir @clone do
      if @spec and @ref
        ohai "Checking out #{@spec} #{@ref}"
        Dir.chdir @clone do
          safe_system 'hg', 'archive', '-y', '-r', @ref, '-t', 'files', dst
        end
      else
        safe_system 'hg', 'archive', '-y', '-t', 'files', dst
      end
    end
  end
end

class BazaarDownloadStrategy <AbstractDownloadStrategy
  def fetch
    raise "You must install bazaar first" \
          unless system "/usr/bin/which bzr"

    ohai "Cloning #{@url}"
    @clone=HOMEBREW_CACHE+@unique_token

    url=@url.sub(%r[^bzr://], '')

    unless @clone.exist?
      # 'lightweight' means history-less
      safe_system 'bzr', 'checkout', '--lightweight', url, @clone
    else
      puts "Updating #{@clone}"
      Dir.chdir(@clone) { safe_system 'bzr', 'update' }
    end
  end

  def stage
    dst=Dir.getwd
    Dir.chdir @clone do
      if @spec and @ref
        ohai "Checking out #{@spec} #{@ref}"
        Dir.chdir @clone do
          safe_system 'bzr', 'export', '-r', @ref, dst
        end
      else
        safe_system 'bzr', 'export', dst
      end
    end
  end
end

def detect_download_strategy url
  case url
  when %r[^cvs://] then CVSDownloadStrategy
  when %r[^hg://] then MercurialDownloadStrategy
  when %r[^svn://] then SubversionDownloadStrategy
  when %r[^svn+http://] then SubversionDownloadStrategy
  when %r[^git://] then GitDownloadStrategy
  when %r[^bzr://] then BazaarDownloadStrategy
  when %r[^https?://(.+?\.)?googlecode\.com/hg] then MercurialDownloadStrategy
  when %r[^https?://(.+?\.)?googlecode\.com/svn] then SubversionDownloadStrategy
  when %r[^https?://(.+?\.)?sourceforge\.net/svnroot/] then SubversionDownloadStrategy
  when %r[^http://svn.apache.org/repos/] then SubversionDownloadStrategy
  else CurlDownloadStrategy
  end
end
