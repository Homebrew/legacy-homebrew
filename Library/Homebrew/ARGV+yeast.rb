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
#
module HomebrewArgvExtension
  def named
    reject{|arg| arg[0..0] == '-'}.collect{|arg| arg.downcase}.uniq
  end
  def options
    select {|arg| arg[0..0] == '-'}
  end
  def formulae
    require 'formula'
    named.collect {|name| Formula.factory name}
  end
  def kegs
    require 'keg'
    named.collect do |name|
      d=HOMEBREW_CELLAR+name
      raise "#{name} is not installed" if not d.directory? or d.children.length == 0
      raise "#{name} has multiple installed versions" if d.children.length > 1
      Keg.new d.children[0]
    end
  end
  
  # self documenting perhaps?
  def include? arg
    @n=index arg
  end
  def next
    at @n+1
  end

  def force?
    flag? '--force'
  end
  def verbose?
    flag? '--verbose'
  end
  def debug?
    flag? '--debug' or ENV['HOMEBREW_DEBUG']
  end

  def flag? flag
    options.each do |arg|
      return true if arg == flag
      next if arg[1..1] == '-'
      return true if arg.include? flag[2..2]
    end
    return false
  end
  
  def usage
    <<-EOS
Usage: brew command [formula] ...
Usage: brew [--prefix] [--cache] [--version]
Usage: brew [--verbose]

Commands:
  install formula ... [--debug] [--interactive]
  rm formula ...
  list formula ...
  ln formula ...
  info [formula] [--github]
  mk url
  prune
  EOS
  end
end

ARGV.extend HomebrewArgvExtension
