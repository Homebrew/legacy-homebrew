require 'formula'

class TodoTxt < Formula
  homepage 'http://todotxt.com/'
  url 'https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.9.tar.gz'
  md5 'e815c63ab4e46285f0b0a30b7bac7918'

  head 'https://github.com/ginatrapani/todo.txt-cli.git'

  def install
    bin.install 'todo.sh'
    prefix.install 'todo.cfg' # Default config file
    prefix.install 'todo_completion' # Bash Completion File
  end

  def caveats
    if File.directory?("#{HOMEBREW_PREFIX}/etc/bash_completion.d")
       <<-EOS.undent
         To configure, copy the default config to your home and edit it:
           cp #{prefix}/todo.cfg ~/.todo.cfg
           
         To install bash completion:
           ln -s #{prefix}/todo_completion #{HOMEBREW_PREFIX}/etc/bash_completion.d/todo      
        EOS
    else
      <<-EOS.undent
        To configure, copy the default config to your home and edit it:
          cp #{prefix}/todo.cfg ~/.todo.cfg
       EOS
    end 
  end
end
