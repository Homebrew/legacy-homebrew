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

require 'pathname'
require 'osx/cocoa' # to get number of cores
require 'env'

# optimise all the way to eleven, references:
# http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel
# http://forums.mozillazine.org/viewtopic.php?f=12&t=577299
# http://gcc.gnu.org/onlinedocs/gcc-4.0.1/gcc/i386-and-x86_002d64-Options.html
ENV['MACOSX_DEPLOYMENT_TARGET']='10.5'
ENV['CFLAGS']=ENV['CXXFLAGS']='-O3 -w -pipe -fomit-frame-pointer -march=prescott'

# lets use gcc 4.2, it is newer and "better", at least I believe so, mail me
# if I'm wrong
ENV['CC']='gcc-4.2'
ENV['CXX']='g++-4.2'
ENV['MAKEFLAGS']="-j#{OSX::NSProcessInfo.processInfo.processorCount}"

unless $root.to_s == '/usr/local'
  ENV['CPPFLAGS']='-I'+$root+'include'
  ENV['LDFLAGS']='-L'+$root+'lib'
end


def ohai title
  n=`tput cols`.strip.to_i-4
  puts "\033[0;34m==>\033[0;0;1m #{title[0,n]}\033[0;0m"
end

def appsupport
  appsupport = File.expand_path "~/Library/Application Support/Homebrew"
  FileUtils.mkpath appsupport
  return appsupport
end

class BuildError <RuntimeError
  def initialize cmd
    super "Build failed during: #{cmd}"
  end
end

# pass in the basename of the filename _without_ any file extension
def extract_version basename
  # eg. boost_1_39_0
  /((\d+_)+\d+)$/.match basename
  return $1.gsub('_', '.') if $1

  # eg. foobar-4.5.1-1
  /-((\d+\.)*\d+-\d+)$/.match basename
  return $1 if $1

  # eg. foobar-4.5.1
  /-((\d+\.)*\d+)$/.match basename
  return $1 if $1

  # eg. foobar-4.5.1b
  /-((\d+\.)*\d+[abc])$/.match basename
  return $1 if $1
  
  # eg. foobar4.5.1
  /((\d+\.)*\d+)$/.match basename
  return $1 if $1

  # eg. otp_src_R13B (this is erlang's style)
  # eg. astyle_1.23_macosx.tar.gz
  basename.scan /_([^_]+)/ do |match|
    return match.first if /\d/.match $1
  end
end


# make our code neater
class Pathname
  def mv dst    
    FileUtils.mv to_s, dst
  end
  
  def rename dst
    dst=Pathname.new dst
    dst.unlink if dst.exist?
    mv dst
  end

  def install src
    FileUtils.mv src, to_s
  end

  def cp dst
    if file?
      FileUtils.cp to_s, dst
    else
      FileUtils.cp_r to_s, dst
    end
  end

  def extname
    /\.(zip|tar\.(gz|bz2)|tgz)$/.match to_s
    return ".#{$1}" if $1
    return File.extname(to_s)
  end

  # for files we support, basename without extension
  def stem
    return File.basename(to_s, extname)
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

  def initialize name=nil
    @name=name
    # fuck knows, ruby is weird
    @url=url if @url.nil?
    raise "@url.nil?" if @url.nil?
    @md5=md5 if @md5.nil?
    # end ruby is weird section
  end

private
  def maybe_mkpath path
    path.mkpath unless path.exist?
    return path
  end

public  
  def prefix
    raise "@name.nil!" if @name.nil?
    raise "@version.nil?" if @version.nil?
    $cellar+@name+@version
  end
  def bin
    maybe_mkpath prefix+'bin'
  end
  def doc
    maybe_mkpath prefix+'share'+'doc'+name
  end
  def man
    maybe_mkpath prefix+'share'+'man'
  end
  def man1
    maybe_mkpath prefix+'share'+'man'+'man1'
  end
  def lib
    maybe_mkpath prefix+'lib'
  end
  def include
    maybe_mkpath prefix+'include'
  end

  def caveats
    nil
  end

  # yields self with current working directory set to the uncompressed tarball
  def brew
    ohai "Downloading #{@url}"
    Dir.chdir appsupport do
      tmp=tgz=nil
      begin
        tgz=Pathname.new(fetch()).realpath
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
        FileUtils.rm tgz if tgz and not self.cache?
      end
    end
  end

  def clean
    [bin,lib].each {|path| path.find do |path|
      if not path.file?
        next
      elsif path.extname == '.la'
        # .la files are stupid
        path.unlink
      else
        fo=`file -h #{path}`
        args=nil
        args='-SxX' if fo =~ /Mach-O dynamically linked shared library/
        args='' if fo =~ /Mach-O executable/ #defaults strip everything
        if args
          puts "Stripping: #{path}" if ARGV.include? '--verbose'
          `strip #{args} #{path}`
        end
      end
    end}
  end

protected
  def cache?
    true
  end
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
    @version=extract_version Pathname.new(File.basename(@url)).stem
  end
end

# see ack.rb for an example usage
class ScriptFileFormula <AbstractFormula
  def cache?
    false
  end
  def install
    FileUtils.cp name, bin
    (bin+name).chmod 0544
  end
end

class GithubGistFormula <ScriptFileFormula
  def initialize
    super File.basename(url)
    @version=File.basename(File.dirname(url))[0,6]
  end
end

def inreplace(path, before, after)
  before=before.to_s.gsub('"', '\"').gsub('/', '\/')
  after=after.to_s.gsub('"', '\"').gsub('/', '\/')

  # we're not using Ruby because the perl script is more concise
  #TODO the above escapes are worse, use a proper ruby script :P
  #TODO optimise it by taking before and after as arrays
  #Bah, just make the script writers do it themselves with a standard collect block
  #TODO use ed -- less to escape
  `perl -pi -e "s/#{before}/#{after}/g" "#{path}"`
end

def system cmd
  ohai cmd

  out=''
  IO.popen("#{cmd} 2>&1") do |f|
    until f.eof?
      s=f.gets
      if ARGV.include? '--verbose'
        puts s
      else
        out+=s
      end
    end
  end

  unless $? == 0
    puts out unless ARGV.include? '--verbose' #already did that above
    raise BuildError.new(cmd)
  end
end

####################################################################### script
if $0 == __FILE__
  d=$cellar.parent+'bin'
  d.mkpath unless d.exist?
  Dir.chdir d
  Pathname.new('brew').make_symlink Pathname.new('../Cellar')+'homebrew'+'brew'
end