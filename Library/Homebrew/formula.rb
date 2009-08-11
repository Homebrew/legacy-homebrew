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


# the base class variety of formula, you don't get a prefix, so it's not
# useful. See the derived classes for fun and games.
class AbstractFormula
  def initialize noop=nil
    @version=self.class.version unless @version
    @url=self.class.url unless @url
    @homepage=self.class.homepage unless @homepage
    @md5=self.class.md5 unless @md5
    @sha1=self.class.sha1 unless @sha1
    raise "@url is nil" if @url.nil?
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
    Formula.path name
  end

  attr_reader :url, :version, :url, :homepage, :name

  def bin; prefix+'bin' end
  def doc; prefix+'share'+'doc'+name end
  def lib; prefix+'lib' end
  def man; prefix+'share'+'man' end
  def man1; man+'man1' end
  def info; prefix+'share'+'info' end
  def include; prefix+'include' end

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
    ohai "Downloading #{@url}"
    tgz=HOMEBREW_CACHE+File.basename(@url)
    unless tgz.exist?
      HOMEBREW_CACHE.mkpath
      curl @url, '-o', tgz
    else
      puts "File already downloaded and cached"
    end

    verify_download_integrity tgz

    mktemp do
      Dir.chdir uncompress(tgz)
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
  def mktemp
    tmp=Pathname.new `mktemp -dt #{File.basename @url}`.strip
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

  # Kernel.system but with exceptions
  def safe_system cmd, *args
    puts "#{cmd} #{args*' '}" if ARGV.verbose?

    execd=Kernel.system cmd, *args
    # somehow Ruby doesn't handle the CTRL-C from another process -- WTF!?
    raise Interrupt, cmd if $?.termsig == 2
    raise ExecutionError.new(cmd, args) unless execd and $? == 0
  end

  def curl url, *args
    safe_system 'curl', '-f#LA', HOMEBREW_USER_AGENT, url, *args
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
      puts "For your reference the #{type} is: #{hash}"
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

  class <<self
    attr_reader :url, :version, :md5, :url, :homepage, :sha1
  end
end

# This is the meat. See the examples.
class Formula <AbstractFormula
  def initialize name=nil
    super
    @name=name
    @version=Pathname.new(@url).version unless @version
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

  # we don't have a std_autotools variant because autotools is a lot less
  # consistent and the standard parameters are more memorable
  # really Homebrew should determine what works inside brew() then
  # we could add --disable-dependency-tracking when it will work
  def std_cmake_parameters
    # The None part makes cmake use the environment's CFLAGS etc. settings
    "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None"
  end

private
  def uncompress_args
    rx=%r[http://(www.)?github.com/.*/(zip|tar)ball/]
    if rx.match @url and $2 == '.zip' or Pathname.new(@url).extname == '.zip'
      %w[unzip -qq]
    else
      %w[tar xf]
    end
  end

  def uncompress path
    safe_system *uncompress_args<<path

    entries=Dir['*']
    if entries.length == 0
      raise "Empty archive"
    elsif entries.length == 1
      # if one dir enter it as that will be where the build is
      entries.first
    else
      # if there's more than one dir, then this is the build directory already
      Dir.pwd
    end
  end

  def method_added method
    raise 'You cannot override Formula.brew' if method == 'brew'
  end
end

# see ack.rb for an example usage
class ScriptFileFormula <AbstractFormula
  def initialize name=nil
    super
    @name=name
  end
  def uncompress path
    path.dirname
  end
  def install
    bin.install File.basename(@url)
  end
end

# see flac.rb for example usage
class GithubGistFormula <ScriptFileFormula
  def initialize name=nil
    super
    @name=name
    @version=File.basename(File.dirname(url))[0,6]
  end
end
