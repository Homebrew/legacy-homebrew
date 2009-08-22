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

def make url
  require 'formula'

  path=Pathname.new url

  /(.*?)[-_.]?#{path.version}/.match path.basename
  raise "Couldn't parse name from #{url}" if $1.nil? or $1.empty?

  path=Formula.path $1
  raise "#{path} already exists" if path.exist?

  template=<<-EOS
            require 'brewkit'

            class #{Formula.class $1} <Formula
              @url='#{url}'
              @homepage=''
              @md5=''

  cmake       def deps
  cmake         BinaryDep.new 'cmake'
  cmake       end
  cmake
              def install
  autotools     system "./configure --prefix='\#{prefix}' --disable-debug --disable-dependency-tracking"
  cmake         system "cmake . \#{cmake_std_parameters}"
                system "make install"
              end
            end
  EOS

  mode=nil
  if ARGV.include? '--cmake'
    mode= :cmake
  elsif ARGV.include? '--autotools'
    mode= :autotools
  end

  f=File.new path, 'w'
  template.each_line do |s|
    if s.strip.empty?
      f.puts
      next
    end
    cmd=s[0..11].strip
    if cmd.empty?
      cmd=nil
    else
      cmd=cmd.to_sym
    end
    out=s[12..-1] || ''

    if mode.nil?
      # we show both but comment out cmake as it is less common
      # the implication being the pacakger should remove whichever is not needed
      if cmd == :cmake and not out.empty?
        f.print '#'
        out = out[1..-1]
      end
    elsif cmd != mode and not cmd.nil?
      next
    end
    f.puts out
  end
  f.close

  return path
end


def info name
  require 'formula'

  history="http://github.com/mxcl/homebrew/commits/masterbrew/Library/Formula/#{Formula.path(name).basename}"
  exec 'open', history if ARGV.flag? '--github'

  f=Formula.factory name
  puts "#{f.name} #{f.version}"
  puts f.homepage

  if f.prefix.parent.directory?
    kids=f.prefix.parent.children
    kids.each do |keg|
      print "#{keg} (#{keg.abv})"
      print " *" if f.prefix == keg and kids.length > 1
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

  puts history

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


def clean f
  Cleaner.new f
  # remove empty directories TODO Rubyize!
  `perl -MFile::Find -e"finddepth(sub{rmdir},'#{f.prefix}')"`
end


def install f
  f.brew do
    if ARGV.flag? '--interactive'
      ohai "Entering interactive mode"
      puts "Type `exit' to return and finalize the installation"
      puts "Install to this prefix: #{f.prefix}"
      interactive_shell
    elsif ARGV.include? '--help'
      system './configure --help'
      exit $?
    else
      f.prefix.mkpath
      f.install
      %w[README ChangeLog COPYING LICENSE COPYRIGHT AUTHORS].each do |file|
        FileUtils.mv "#{file}.txt", file rescue nil
        f.prefix.install file rescue nil
      end
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
    raise "Couldn't determine version, try --set-version" if version.nil? or version.empty?
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
  end
end

################################################################ class Cleaner
class Cleaner
  def initialize f
    @f=f
    
    # correct common issues
    share=f.prefix+'share'
    (f.prefix+'man').mv share rescue nil
    
    [f.bin, f.sbin, f.lib].each {|d| clean_dir d}
    
    # you can read all of this shit online nowadays, save the space
    # info pages are shit, everyone agrees apart from Richard Stallman
    (f.prefix+'share'+'doc').rmtree rescue nil
    (f.prefix+'share'+'info').rmtree rescue nil
    (f.prefix+'doc').rmtree rescue nil
    (f.prefix+'info').rmtree rescue nil
  end

private
  def strip path, args=''
    return if @f.skip_clean? path
    puts "strip #{path}" if ARGV.verbose?
    path.chmod 0644 # so we can strip
    unless path.stat.nlink > 1
      `strip #{args} #{path}`
    else
      # strip unlinks the file and recreates it, thus breaking hard links!
      # is this expected behaviour? patch does it too… still,mktm this fixes it
      tmp=`mktemp -t #{path.basename}`.strip
      `strip #{args} -o #{tmp} #{path}`
      `cat #{tmp} > #{path}`
      File.unlink tmp
    end
  end

  def clean_file path
    perms=0444
    case `file -h #{path}`
      when /Mach-O dynamically linked shared library/
        strip path, '-SxX'
      when /Mach-O [^ ]* ?executable/
        strip path
        perms=0544
      when /script text executable/
        perms=0544
    end
    path.chmod perms
  end

  def clean_dir d
    d.find do |path|
      if path.directory?
        Find.prune if @f.skip_clean? path
      elsif not path.file?
        next
      elsif path.extname == '.la' and not @f.skip_clean? path
        # *.la files are stupid
        path.unlink
      else
        clean_file path
      end
    end
  end
end
