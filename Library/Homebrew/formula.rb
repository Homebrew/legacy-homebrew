#  Copyright 2009 Max Howell and other contributors.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
class ExecutionError <RuntimeError
  def initialize cmd, args=[]
    super "Failure while executing: #{cmd} #{args*' '}"
  end
end
class BuildError <ExecutionError
end
class FormulaUnavailableError <RuntimeError
  def initialize name
    super "No available formula for #{name}"
  end
end


# Derive and define at least @url, see Library/Formula for examples
class Formula
  # Homebrew determines the name
  def initialize name='__UNKNOWN__'
    @url=self.class.url unless @url

    @head=self.class.head unless @head
    if @head and (not @url or ARGV.flag? '--HEAD')
      @url=@head
      @version='HEAD'
    end

    raise if @url.nil?
    @name=name
    validate_variable :name
    @version=self.class.version unless @version
    @version=Pathname.new(@url).version unless @version
    validate_variable :version if @version
    @homepage=self.class.homepage unless @homepage
    CHECKSUM_TYPES.each do |type|
      if !instance_variable_defined?("@#{type}")
        class_value = self.class.send(type)
        instance_variable_set("@#{type}", class_value) if class_value
      end
    end
  end

  # if the dir is there, but it's empty we consider it not installed
  def installed?
    return prefix.children.length > 0
  rescue
    return false
  end

  def prefix
    validate_variable :name
    validate_variable :version
    HOMEBREW_CELLAR+@name+@version
  end

  def path
    self.class.path name
  end

  attr_reader :url, :version, :homepage, :name

  def bin; prefix+'bin' end
  def sbin; prefix+'sbin' end
  def doc; prefix+'share'+'doc'+name end
  def etc; prefix+'etc' end
  def lib; prefix+'lib' end
  def libexec; prefix+'libexec' end
  def man; prefix+'share'+'man' end
  def man1; man+'man1' end
  def info; prefix+'share'+'info' end
  def include; prefix+'include' end
  def share; prefix+'share' end

  # reimplement if we don't autodetect the download strategy you require
  def download_strategy
    case url
      when %r[^svn://] then SubversionDownloadStrategy
      when %r[^git://] then GitDownloadStrategy
      when %r[^http://(.+?\.)?googlecode\.com/svn] then SubversionDownloadStrategy
      when %r[^http://svn.apache.org/repos/] then SubversionDownloadStrategy
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
    validate_variable :name
    validate_variable :version
    
    stage do
      begin
        patch
        yield self
      rescue Interrupt, RuntimeError, SystemCallError => e
        raise unless ARGV.debug?
        onoe e.inspect
        puts e.backtrace
        ohai "Rescuing build..."
        puts "When you exit this shell Homebrew will attempt to finalise the installation."
        puts "If nothing is installed or the shell exits with a non-zero error code,"
        puts "Homebrew will abort. The installation prefix is:"
        puts prefix
        interactive_shell
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
        puts "Exit code: #{$?}"
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
    # I used /tmp rather than mktemp -td because that generates a directory
    # name with exotic characters like + in it, and these break badly written
    # scripts that don't escape strings before trying to regexp them :(
    tmp=Pathname.new `mktemp -d /tmp/homebrew-#{name}-#{version}-XXXX`.strip
    raise "Couldn't create build sandbox" if not tmp.directory? or $? != 0
    begin
      wd=Dir.pwd
      Dir.chdir tmp
      yield
    ensure
      Dir.chdir wd
      tmp.rmtree
    end
  end

  CHECKSUM_TYPES=[:md5, :sha1, :sha256].freeze

  def verify_download_integrity fn
    require 'digest'
    type=CHECKSUM_TYPES.detect { |type| instance_variable_defined?("@#{type}") }
    type ||= :md5
    supplied=instance_variable_get("@#{type}")
    type=type.to_s.upcase
    hash=Digest.const_get(type).hexdigest(fn.read)

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

  def validate_variable name
    v=eval "@#{name}"
    raise "Invalid @#{name}" if v.to_s.empty? or v =~ /\s/
  end

  def method_added method
    raise 'You cannot override Formula.brew' if method == 'brew'
  end

  class <<self
    attr_reader :url, :version, :homepage, :head
    attr_reader *CHECKSUM_TYPES
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
  def initialize name='__UNKNOWN__'
    super name
    @version=File.basename(File.dirname(url))[0,6]
  end
end
