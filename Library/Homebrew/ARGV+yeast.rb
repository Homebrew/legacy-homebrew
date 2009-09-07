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
module HomebrewArgvExtension
  def named
    raise UsageError if _named.empty?
    _named
  end
  def named_empty?
    _named.empty?
  end
  def options
    select {|arg| arg[0..0] == '-'}
  end
  def formulae
    require 'formula'
    @formulae ||= named.collect {|name| Formula.factory name}
  end
  def kegs
    require 'keg'
    @kegs ||= named.collect do |name|
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
  def quieter?
    flag? '--quieter'
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
Usage: brew [--verbose|-v]

Commands:
  install formula ... [--debug|-d] [--interactive|-i]
  remove formula ...
  search [regex]
  list [formula] ...
  link formula ...
  home formula ...
  info [formula] [--github]
  gen url
  prune
  update

To visit the Homebrew homepage type:
  brew home
  EOS
  end

private
  def _named
    @named ||= reject{|arg| arg[0..0] == '-'}.collect{|arg| arg.downcase}.uniq
  end
end

class UsageError <RuntimeError; end

ARGV.extend HomebrewArgvExtension
