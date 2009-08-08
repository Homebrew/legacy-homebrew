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

# args are additional inputs to puts until a nil arg is encountered
def ohai title, *args
  return if args.length > 0 and args[0].nil?
  n=`tput cols`.strip.to_i-4
  puts "\033[0;34m==>\033[0;0;1m #{title[0,n]}\033[0;0m"
  args.each do |arg|
    return if arg.nil?
    puts arg
  end
end

# shows a warning in delicious pink
def opoo warning
  puts "\033[1;35m==>\033[0;0;1m Warning\033[0;0m: #{warning}"
end

def onoe error
  puts "\033[1;31m==>\033[0;0;1m Error\033[0;0m: #{error}"
end

def pretty_duration s
  return "#{(s*1000).to_i} milliseconds" if s < 3
  return "#{s.to_i} seconds" if s < 10*60
  return "#{(s/60).to_i} minutes"
end

def interactive_shell
  pid=fork
  if pid.nil?
    exec ENV['SHELL']
  else
    Process.wait pid
  end
end
