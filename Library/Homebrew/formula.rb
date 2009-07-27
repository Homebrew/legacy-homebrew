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

require 'env'

class BuildError <RuntimeError
  def initialize cmd
    super "Build failed during: #{cmd}"
  end
end

# the base class variety of formula, you don't get a prefix, so it's not really
# useful. See the derived classes for fun and games.
class AbstractFormula
  require 'find'
  require 'fileutils'

  # fuck knows, ruby is weird
  # TODO please fix!
  def self.url
    @url
  end
  def url
    self.class.url
  end
  def self.md5
    @md5
  end
  def md5
    self.class.md5
  end
  def self.homepage
    @homepage
  end
  def homepage
    self.class.homepage
  end  
  # end ruby is weird section

  def version
    @version
  end
  def name
    @name
  end

  # if the dir is there, but it's empty we consider it not installed
  def installed?
    return prefix.children.count > 0
  rescue
    return false
  end

  def initialize name=nil
    @name=name
    # fuck knows, ruby is weird
    @url=url if @url.nil?
    raise "@url.nil?" if @url.nil?
    @md5=md5 if @md5.nil?
    # end ruby is weird section
  end

public  
  def prefix
    raise "@name.nil!" if @name.nil?
    raise "@version.nil?" if @version.nil?
    $cellar+@name+@version
  end
  def bin
    prefix+'bin'
  end
  def doc
    prefix+'share'+'doc'+name
  end
  def man
    prefix+'share'+'man'
  end
  def man1
    man+'man1'
  end
  def lib
    prefix+'lib'
  end
  def include
    prefix+'include'
  end

  def caveats
    nil
  end
  
  # Pretty titles the command and buffers stdout/stderr
  # Throws if there's an error
  def system cmd
    ohai cmd
    if ARGV.include? '--verbose'
      Kernel.system cmd
    else
      out=''
      IO.popen "#{cmd} 2>&1" do |f|
        until f.eof?
          out+=f.gets
        end
      end
      puts out unless $? == 0
    end

    raise BuildError.new(cmd) unless $? == 0
  end

  # yields self with current working directory set to the uncompressed tarball
  def brew
    ohai "Downloading #{@url}"
    FileUtils.mkpath HOMEBREW_CACHE
    Dir.chdir HOMEBREW_CACHE do
      tmp=nil
      tgz=Pathname.new(fetch()).realpath
      begin
        md5=`md5 -q "#{tgz}"`.strip
        raise "MD5 mismatch: #{md5}" unless @md5 and md5 == @md5.downcase

        # we make an additional subdirectory so know exactly what we are
        # recursively deleting later
        # we use mktemp rather than appsupport/blah because some build scripts
        # can't handle being built in a directory with spaces in it :P
        tmp=`mktemp -dt #{File.basename @url}`.strip
        Dir.chdir tmp do
          Dir.chdir uncompress(tgz) do
            yield self
          end
        end
      rescue Interrupt, RuntimeError
        if ARGV.include? '--debug'
          # debug mode allows the packager to intercept a failed build and
          # investigate the problems
          puts "Rescued build at: #{tmp}"
          exit! 1
        else
          raise
        end
      ensure
        FileUtils.rm_rf tmp if tmp
      end
    end
  end

protected
  # returns the directory where the archive was uncompressed
  # in this Abstract case we assume there is no archive
  def uncompress path
    path.dirname
  end

private
  def fetch
    %r[http://(www.)?github.com/.*/(zip|tar)ball/].match @url
    if $2
      # curl doesn't do the redirect magic that we would like, so we get a
      # stupidly named file, this is why wget would be beter, but oh well
      tgz="#{@name}-#{@version}.#{$2=='tar' ? 'tgz' : $2}"
      oarg="-o #{tgz}"
    else
      oarg='-O' #use the filename that curl gets
      tgz=File.expand_path File.basename(@url)
    end

    agent="Homebrew #{HOMEBREW_VERSION} (Ruby #{VERSION}; Mac OS X 10.5 Leopard)"

    unless File.exists? tgz
      `curl -#LA "#{agent}" #{oarg} "#{@url}"`
      raise "Download failed" unless $? == 0
    else
      puts "File already downloaded and cached"
    end
    return tgz
  end

  def method_added method
    raise 'You cannot override Formula.brew' if method == 'brew'
  end
end

# somewhat useful, it'll raise if you call prefix, but it'll unpack a tar/zip
# for you, check the md5, and allow you to yield from brew
class UnidentifiedFormula <AbstractFormula
  def initialize name=nil
    super name
  end

private
  def uncompress(path)
    if path.extname == '.zip'
      `unzip -qq "#{path}"`
    else
      `tar xf "#{path}"`
    end

    raise "Compression tool failed" if $? != 0

    entries=Dir['*']
    if entries.nil? or entries.length == 0
      raise "Empty tarball!" 
    elsif entries.length == 1
      # if one dir enter it as that will be where the build is
      entries.first
    else
      # if there's more than one dir, then this is the build directory already
      Dir.pwd
    end
  end  
end

# this is what you will mostly use, reimplement install, prefix won't raise
class Formula <UnidentifiedFormula
  def initialize name
    super name
    @version=Pathname.new(@url).version unless @version
  end
  
  def self.class name
    #remove invalid characters and camelcase
    name.capitalize.gsub(/[-_\s]([a-zA-Z0-9])/) { $1.upcase }
  end

  def self.path name
    $formula+(name.downcase+'.rb')
  end
  
  def self.create name
    require Formula.path(name)
    return eval(Formula.class(name)).new(name)
  rescue
    raise "No formula for #{name}"
  end
end

# see ack.rb for an example usage
class ScriptFileFormula <AbstractFormula
  def install
    bin.install name
  end
end

class GithubGistFormula <ScriptFileFormula
  def initialize
    super File.basename(url)
    @version=File.basename(File.dirname(url))[0,6]
  end
end
