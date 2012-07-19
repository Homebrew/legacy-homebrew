require 'formula'

class TodoTxt < Formula
  homepage 'http://todotxt.com/'
  url 'https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.9.tar.gz'
  md5 'e815c63ab4e46285f0b0a30b7bac7918'

  head 'https://github.com/ginatrapani/todo.txt-cli.git'

  def install
    bin.install 'todo.sh'
    prefix.install 'todo.cfg' # Default config file
    (prefix+'etc/bash_completion.d').install 'todo_completion'
  end
end
