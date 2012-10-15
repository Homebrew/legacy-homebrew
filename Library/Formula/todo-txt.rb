require 'formula'

class TodoTxt < Formula
  homepage 'http://todotxt.com/'
  url 'https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.9.tar.gz'
  sha1 'b8b351f287c4f5a6510e08e14757db14d0cd1da7'

  head 'https://github.com/ginatrapani/todo.txt-cli.git'

  def install
    bin.install 'todo.sh'
    prefix.install 'todo.cfg' # Default config file
    (prefix+'etc/bash_completion.d').install 'todo_completion'
  end

  def caveats; <<-EOS.undent
    To configure, copy the default config to your HOME and edit it:
      cp #{prefix}/todo.cfg ~/.todo.cfg
    EOS
  end
end
