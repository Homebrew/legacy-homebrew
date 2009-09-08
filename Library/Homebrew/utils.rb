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
  n=title.length if ARGV.verbose?
  puts "\033[0;34m==>\033[0;0;1m #{title[0,n]}\033[0;0m"
  args.each do |arg|
    return if arg.nil?
    puts arg
  end
end

# shows a warning in delicious pink
def opoo warning
  puts "\033[1;35m==>\033[0;0;1m Warning!\033[0;0m #{warning}"
end

def onoe error
  puts "\033[1;31m==>\033[0;0;1m Error\033[0;0m: #{error}"
end

def pretty_duration s
  return "2 seconds" if s < 3 # avoids the plural problem ;)
  return "#{s.to_i} seconds" if s < 120
  return "%.1f minutes" % (s/60)
end

def interactive_shell
  pid=fork
  if pid.nil?
    # TODO make the PS1 var change pls
    #brown="\[\033[0;33m\]"
    #reset="\[\033[0m\]"
    #ENV['PS1']="Homebrew-#{HOMEBREW_VERSION} #{brown}\W#{reset}\$ "
    exec ENV['SHELL']
  end
  Process.wait pid
  raise SystemExit, "Aborting due to non-zero exit status" if $? != 0
end

# Kernel.system but with exceptions
def safe_system cmd, *args
  puts "#{cmd} #{args*' '}" if ARGV.verbose?
  exec_success=Kernel.system cmd, *args
  # some tools, eg. tar seem to confuse ruby and it doesn't propogate the
  # CTRL-C interrupt to us too, so execution continues, but the exit code os
  # still 2 so we raise our own interrupt
  raise Interrupt, cmd if $?.termsig == 2
  unless exec_success and $?.success?
    puts "Exit code: #{$?}"
    raise ExecutionError.new(cmd, args)
  end 
end

def curl url, *args
  safe_system 'curl', '-f#LA', HOMEBREW_USER_AGENT, url, *args
end

def puts_columns items, cols = 4
  items = items.join("\n") if items.is_a?(Array)
  width=`stty size`.chomp.split(" ").last
  IO.popen("pr -#{cols} -t", "w"){|io| io.write(items) }
end

def exec_editor *args
  editor=ENV['EDITOR']
  if editor.nil?
    if system "which -s mate" and $?.success?
      editor='mate'
    else
      editor='vim'
    end
  end
  # we split the editor because especially on mac "mate -w" is common
  # but we still want to use the comma-delimited version of exec because then
  # we don't have to escape args, and escaping 100% is tricky
  exec *(editor.split+args)
end

# provide an absolute path to a command or this function will search the PATH
def arch_for_command cmd
    archs = []
    cmd = `which #{cmd}` if not Pathname.new(cmd).absolute?

    IO.popen("file #{cmd}").readlines.each do |line|
      case line
      when /Mach-O executable ppc/
        archs << :ppc7400
      when /Mach-O 64-bit executable ppc64/
        archs << :ppc64
      when /Mach-O executable i386/
        archs << :i386
      when /Mach-O 64-bit executable x86_64/
        archs << :x86_64
      end
    end

    return archs
end
