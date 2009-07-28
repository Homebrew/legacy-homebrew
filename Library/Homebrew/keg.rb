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
require 'formula'

class Keg
  attr_reader :path, :version, :name
  
  def initialize formula
    if formula.is_a? AbstractFormula
      @path=formula.prefix
      @name=formula.name
      @version=formula.version
    elsif formula.is_a? Pathname
      # TODO
    elsif formula.is_a? String
      kids=($cellar+formula).children
      raise "Multiple versions installed" if kids.length > 1
      @path=kids[0]
      @name=formula
      @version=@path.basename
    end
  end

  def clean
    # TODO unset write permission more
    %w[bin lib].each {|d| (Pathname.new(path)+d).find do |path|
      if not path.file?
        next
      elsif path.extname == '.la'
        # .la files are stupid
        path.unlink
      else
        fo=`file -h #{path}`
        args=nil
        perms=0444
        if fo =~ /Mach-O dynamically linked shared library/
          args='-SxX'
        elsif fo =~ /Mach-O executable/ # defaults strip everything
          args='' # still do the strip
          perms=0544
        elsif fo =~ /script text executable/
          perms=0544
        end
        if args
          puts "Stripping: #{path}" if ARGV.include? '--verbose'
          path.chmod 0644 # so we can strip
          unless path.stat.nlink > 1
            `strip #{args} #{path}`
          else
            # strip unlinks the file and recreates it, thus breaking hard links!
            # is this expected behaviour? patch does it too… still,mktm this fixes it
            tmp=`mktemp -t #{path.basename}`.strip
            `strip -o #{tmp} #{path}`
            `cat #{tmp} > #{path}`
            File.unlink tmp
          end
        end
        path.chmod perms
      end
    end}

    # remove empty directories TODO Rubyize!
    `perl -MFile::Find -e"finddepth(sub{rmdir},'#{path}')"`
  end

  def rm
    # don't rmtree shit if we aren't positive about our location!
    raise "Bad stuff!" unless path.parent.parent == $cellar

    if path.directory?
      FileUtils.chmod_R 0777, path # ensure we have permission to delete
      path.rmtree # $cellar/foo/1.2.0
      path.parent.rmdir if path.parent.children.length == 0 # $cellar/foo
    end
  end

private
  def __symlink_relative_to from, to
    tod=to.dirname
    tod.mkpath
    Dir.chdir(tod) do
      #TODO use Ruby function so we get exceptions
      #NOTE Ruby functions are fucked up!
      `ln -sf "#{from.relative_path_from tod}"`
      @n+=1
    end
  end

  # symlinks a directory recursively into our FHS tree
  def __ln start
    start=path+start
    return unless start.directory?

    start.find do |from|
      next if from == start

      prune=false

      relative_path=from.relative_path_from path
      to=$root+relative_path

      if from.file?
        __symlink_relative_to from, to
      elsif from.directory?
        # no need to put .app bundles in the path, the user can just use
        # spotlight, or the open command and actual mac apps use an equivalent
        Find.prune if from.extname.to_s == '.app'

        branch=from.relative_path_from start

        case yield branch when :skip
          Find.prune
        when :mkpath
          to.mkpath
          @n+=1
        else
          __symlink_relative_to from, to
          Find.prune
        end
      end
    end
  end

public
  def ln
    # yeah indeed, you have to force anything you need in the main tree into
    # these dirs REMEMBER that *NOT* everything needs to be in the main tree
    # TODO consider using hardlinks
    @n=0

    __ln('etc') {:mkpath}
    __ln('bin') {:link}
    __ln('lib') {|path| :mkpath if ['pkgconfig','php'].include? path.to_s}
    __ln('include') {:link}

    mkpaths=(1..9).collect {|x| "man/man#{x}"} <<'man'<<'doc'<<'locale'<<'info'<<'aclocal'
    __ln('share') {|path| :mkpath if mkpaths.include? path.to_s}

    return @n
  end
end