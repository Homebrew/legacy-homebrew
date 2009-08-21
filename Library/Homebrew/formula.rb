#  Copyright 2009 Max Howell <max@methylblue.com>
#
#  This file is part of Homebrew.
#
#  Homebrew is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Homebrew is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Homebrew.  If not, see <http://www.gnu.org/licenses/>.


class AbstractDownloadStrategy
  def initialize url, name, version
    @url=url
    @unique_token="#{name}-#{version}"
  end
end

class HttpDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Downloading #{@url}"
    @dl=HOMEBREW_CACHE+(@unique_token+ext)
    unless @dl.exist?
      curl @url, '-o', @dl
    else
      puts "File already downloaded and cached"
    end
    return @dl # thus performs checksum verification
  end
  def stage
    case `file -b #{@dl}`
      when /^Zip archive data/
        safe_system 'unzip', '-qq', @dl
        chdir
      when /^(gzip|bzip2) compressed data/
        # TODO do file -z now to see if it is in fact a tar
        safe_system 'tar', 'xf', @dl
        chdir
      else
        # we are assuming it is not an archive, use original filename
        # this behaviour is due to ScriptFileFormula expectations
        @dl.mv File.basename(@url)
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

class SubversionDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Checking out #{@url}"
    @co=HOMEBREW_CACHE+@unique_token
    unless @co.exist?
      safe_system 'svn', 'checkout', @url, @co
    else
      # TODO svn up?
      puts "Repository already checked out"
    end
  end
  def stage
    # Force the export, since the target directory will already exist
    safe_system 'svn', 'export', '--force', @co, Dir.pwd
  end
end

class GitDownloadStrategy <AbstractDownloadStrategy
  def fetch
    ohai "Cloning #{@url}"
    @clone=HOMEBREW_CACHE+@unique_token
    unless @clone.exist?
      safe_system 'git', 'clone', @url, @clone
    else
      # TODO git pull?
      puts "Repository already cloned"
    end
  end
  def stage
    dst=Dir.getwd
    Dir.chdir @clone do
      # http://stackoverflow.com/questions/160608/how-to-do-a-git-export-like-svn-export
      safe_system 'git', 'checkout-index', '-af', "--prefix=#{dst}"
    end
  end
end


class ExecutionError <RuntimeError
  def initialize cmd, args=[]
    super "#{cmd} #{args*' '}"
  end
end

class BuildError <ExecutionError; end

class FormulaUnavailableError <RuntimeError
  def initialize name
    super "No available formula for #{name}"
  end
end


# Derive and define at least @url, see Library/Formula for examples
class Formula
  # Homebrew determines the name
  def initialize name=nil
    @url=self.class.url unless @url
    raise if @url.nil?
    @name=name
    raise if @name =~ /\s/
    @version=self.class.version unless @version
    @version=Pathname.new(@url).version unless @version
    raise if @version =~ /\s/
    @homepage=self.class.homepage unless @homepage
    @md5=self.class.md5 unless @md5
    @sha1=self.class.sha1 unless @sha1
  end

  # if the dir is there, but it's empty we consider it not installed
  def installed?
    return prefix.children.length > 0
  rescue
    return false
  end

  def prefix
    raise "Invalid @name" if @name.nil? or @name.empty?
    raise "Invalid @version" if @version.nil? or @version.empty?
    HOMEBREW_CELLAR+@name+@version
  end

  def path
    self.class.path name
  end

  attr_reader :url, :version, :homepage, :name

  def bin; prefix+'bin' end
  def sbin; prefix+'sbin' end
  def doc; prefix+'share'+'doc'+name end
  def lib; prefix+'lib' end
  def man; prefix+'share'+'man' end
  def man1; man+'man1' end
  def info; prefix+'share'+'info' end
  def include; prefix+'include' end

  # reimplement if we don't autodetect the download strategy you require
  def download_strategy
    case url
      when %r[^svn://] then SubversionDownloadStrategy
      when %r[^git://] then GitDownloadStrategy
      when %r[^http://(.+?\.)?googlecode\.com/svn] then SubversionDownloadStrategy
      else HttpDownloadStrategy
    end
  end
  # tell the user about any caveats regarding this package
  def caveats; nil end
  # patches are automatically applied after extracting the tarball
  # return an array of strings, or if you need a patch level other than -p0
  # return a Hash eg.
  #   {
  #     :p0 => ['http://foo.com/patch1', 'http://foo.com/patch2'],
  #     :p1 =>  'http://bar.com/patch2',
  #     :p2 => ['http://moo.com/patch5', 'http://moo.com/patch6']
  #   }
  def patches; [] end
  # reimplement and specify dependencies
  def deps; end
  # sometimes the clean process breaks things, return true to skip anything
  def skip_clean? path; false end

  # yields self with current working directory set to the uncompressed tarball
  def brew
    stage do
      begin
        patch
        yield self
      rescue Interrupt, RuntimeError, SystemCallError => e
        raise unless ARGV.debug?
        onoe e.inspect
        puts e.backtrace
        ohai "Rescuing build..."
        puts "Type `exit' and Homebrew will attempt to finalize the installation"
        puts "If nothing is installed to #{prefix}, then Homebrew will abort"
        interactive_shell
        raise "Non-zero exit status, installation aborted" if $? != 0
      end
    end
  end

  # we don't have a std_autotools variant because autotools is a lot less
  # consistent and the standard parameters are more memorable
  # really Homebrew should determine what works inside brew() then
  # we could add --disable-dependency-tracking when it will work
  def std_cmake_parameters
    # The None part makes cmake use the environment's CFLAGS etc. settings
    "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None"
  end

  def self.class name
    #remove invalid characters and camelcase
    name.capitalize.gsub(/[-_\s]([a-zA-Z0-9])/) { $1.upcase }
  end

  def self.factory name
    require self.path(name)
    return eval(self.class(name)).new(name)
  rescue LoadError
    raise FormulaUnavailableError.new(name)
  end

  def self.path name
    HOMEBREW_PREFIX+'Library'+'Formula'+"#{name.downcase}.rb"
  end

protected
  # Pretty titles the command and buffers stdout/stderr
  # Throws if there's an error
  def system cmd, *args
    full="#{cmd} #{args*' '}".strip
    ohai full
    if ARGV.verbose?
      safe_system cmd, *args
    else
      out=''
      # TODO write a ruby extension that does a good popen :P
      IO.popen "#{full} 2>&1" do |f|
        until f.eof?
          out+=f.gets
        end
      end
      unless $? == 0
        puts out
        raise
      end
    end
  rescue
    raise BuildError.new(cmd, args)
  end

private
  # creates a temporary directory then yields, when the block returns it
  # recursively deletes the temporary directory
  def mktemp
    tmp=Pathname.new `mktemp -dt #{name}-#{version}`.strip
    raise if not tmp.directory? or $? != 0
    begin
      wd=Dir.pwd
      Dir.chdir tmp
      yield
    ensure
      Dir.chdir wd
      tmp.rmtree
    end
  end

  def verify_download_integrity fn
    require 'digest'
    type='MD5'
    type='SHA1' if @sha1
    supplied=eval "@#{type.downcase}"
    hash=eval("Digest::#{type}").hexdigest(fn.read)

    if supplied and not supplied.empty?
      raise "#{type} mismatch: #{hash}" unless supplied.upcase == hash.upcase
    else
      opoo "Cannot verify package integrity"
      puts "The formula did not provide a download checksum"
      puts "For your reference the #{type} is: #{hash}"
    end
  end

  def stage
    ds=download_strategy.new url, name, version
    HOMEBREW_CACHE.mkpath
    dl=ds.fetch
    verify_download_integrity dl if dl.kind_of? Pathname
    mktemp do
      ds.stage
      yield
    end
  end

  def patch
    return if patches.empty?
    ohai "Patching"
    if patches.kind_of? Hash
      patch_args=[]
      curl_args=[]
      n=0
      patches.each do |arg, urls|
        urls.each do |url|
          dst='%03d-homebrew.patch' % n+=1
          curl_args<<url<<'-o'<<dst
          patch_args<<["-#{arg}",'-i',dst]
        end
      end
      # downloading all at once is much more efficient, espeically for FTP
      curl *curl_args
      patch_args.each do |args|
        # -f means it doesn't prompt the user if there are errors, if just
        # exits with non-zero status
        safe_system 'patch', '-f', *args
      end
    else
      ff=(1..patches.length).collect {|n| '%03d-homebrew.patch'%n}
      curl *patches+ff.collect {|f|"-o#{f}"}
      ff.each {|f| safe_system 'patch', '-p0', '-i', f}
    end
  end

  def method_added method
    raise 'You cannot override Formula.brew' if method == 'brew'
  end

  class <<self
    attr_reader :url, :svnurl, :version, :homepage, :md5, :sha1
  end
end

# see ack.rb for an example usage
class ScriptFileFormula <Formula
  def install
    bin.install Dir['*']
  end
end

# see flac.rb for example usage
class GithubGistFormula <ScriptFileFormula
  def initialize name=nil
    @version=File.basename(File.dirname(url))[0,6]
    super name
  end
end
