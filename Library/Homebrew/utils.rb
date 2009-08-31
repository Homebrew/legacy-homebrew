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
  exec ENV['SHELL'] if pid.nil?
  Process.wait pid
  raise SystemExit, "Aborting due to non-zero exit status" if $? != 0
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
