# Copyright 2009 Max Howell <max@methylblue.com>
# Licensed as per the GPL version 3
require 'pathname'

$agent = "Homebrew 0.1 (Ruby; Mac OS X 10.5 Leopard)"
$cellar = Pathname.new(__FILE__).dirname.parent.realpath

#TODO don't add the prefixes if we're in /usr or /usr/local
ENV['MACOSX_DEPLOYMENT_TARGET']='10.5'
ENV['CFLAGS']=ENV['CXXFLAGS']='-O3 -w'
ENV['CPPFLAGS']="-I#{$cellar.parent}/include"
ENV['LDFLAGS']="-L#{$cellar.parent}/lib"


def ohai title
  puts "\033[0;34m==>\033[0;0;1m #{title} \033[0;0m"
end


class Formula
  require 'find'
  require 'fileutils'

  # if you reimplement, assign @name, @version, @url and @md5
  def initialize(url, md5)
    @name = File.basename $0, '.rb' #original script that the interpreter started
    @url = url
    @md5 = md5

    # pls improve this version extraction crap
    filename=File.basename url
    i=filename.index /[-_]\d/
    unless i.nil?
      /^((\d+[.-])*\d+)/.match filename[i+1,1000] #1000 because rubysucks
      @version = $1
    else
      # no divisor or a '.' divisor, eg. dmd.1.11.zip
      /^[a-zA-Z._-]*((\d+\.)*\d+)/.match filename
      @version = $1
    end
  end

  #yields a Pathname object for the installation prefix
  def brew
    raise "@name.nil?" if @name.nil?
    raise "@version.nil?" if @version.nil?

    # disabled until the regexp makes sense :P
    #raise "@name does not validate to our regexp" unless /^\w+$/ =~ @name

    beginning = Time.now

    prefix=$cellar+@name+@version
    raise "#{prefix} already exists!" if prefix.exist?

    ohai "Preparing build"

    appsupport = File.expand_path "~/Library/Application Support/Homebrew"
    FileUtils.mkpath appsupport unless File.exist? appsupport
    Dir.chdir appsupport do
      tgz=Pathname.new fetch()
      md5=`md5 -q "#{tgz}"`.strip
      raise "MD5 mismatch: #{md5}" unless md5 == @md5.downcase

      # we make an additional subdirectory so know exactly what we are
      # recursively deleting later
      # we use mktemp rather than appsupport/blah because some build scripts
      # can't handle being built in a directory with spaces in it :P
      tmp=nil
      begin
        tmp=`mktemp -dt #{@name}-#{@version}`.strip
        Dir.chdir tmp do
          Dir.chdir uncompress(tgz) do
            caveats = yield prefix
            if caveats
              ohai "Caveats"
              puts caveats
              ohai "Summary"
            end
            #TODO copy changelog or CHANGES file to pkg root,
            #TODO maybe README, etc. to versioned root
          end
        end
      ensure
        FileUtils.rm_rf tmp
      end

      # stay in appsupport in case any odd files gets created etc.
      `#{$cellar}/homebrew/brew ln #{prefix}` if prefix.exist?

      puts "#{prefix}: "+`find #{prefix} -type f | wc -l`.strip+' files, '+`du -hd0 #{prefix} | cut -d"\t" -f1`.strip+", built in #{Time.now - beginning} seconds"
    end
  end

  def version
    @version
  end
  def name
    @name
  end

protected
  def fetch
    tgz=File.expand_path File.basename(@url)
    unless File.exists? tgz
      `curl -LOA "#{$agent}" "#{@url}"`
      raise "Download failed" unless $? == 0
    end
    return tgz
  end

  def uncompress(path)
    if path.extname == '.zip'
      `unzip -qq "#{path}"`
    else
      `tar xf "#{path}"`
    end

    raise "Compression tool failed" if $? != 0

    entries=Dir['*']
    raise "Empty tar!" if entries.nil? or entries.length == 0
    raise "Too many folders in uncompressed result. You need to reimplement the Recipe.uncompress function." if entries.length > 1
    return entries.first
  end

private
  def method_added(method)
    raise 'You cannot override Formula.brew' if method == 'brew'
  end
end


def inreplace(path, before, after)
  # we're not using Ruby because the perl script is more concise
  `perl -pi -e "s|#{before}|#{after}|g" "#{path}"`
end

def system cmd
  ohai cmd

  out=''
  IO.popen("#{cmd} 2>1") do |f|
    until f.eof?
      s=f.gets
      out+=s
      puts s if ARGV.include? '--verbose'
    end
  end

  unless $? == 0
    puts out unless ARGV.include? '--verbose' #already did that above
    raise "Failure during: #{cmd}"
  end
end

# force a prettier exception handler unless --verbose or HOMEBREW_DEBUG
Kernel.at_exit {
  unless ARGV.include? '--verbose' or ENV['HOMEBREW_DEBUG']
    puts "\033[1;31mError\033[0;0m: #{$!}" if $!
    exit! 1
  end
}

########################################################################script
if $0 == __FILE__
  d=$cellar.parent+'bin'
  d.mkpath unless d.exist?
  (d+'brew').make_symlink $cellar+'homebrew'+'brew'
end