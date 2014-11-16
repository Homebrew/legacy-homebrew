require 'formula'

class TodoTxt < Formula
  homepage 'http://todotxt.com/'
  url "https://github.com/ginatrapani/todo.txt-cli/releases/download/v2.10/todo.txt_cli-2.10.tar.gz"
  sha1 "3967bc42ca23cc984e94939b783cf118fe86b1b0"

  head 'https://github.com/ginatrapani/todo.txt-cli.git'

  def install
    bin.install 'todo.sh'
    prefix.install 'todo.cfg' # Default config file
    bash_completion.install 'todo_completion'
  end

  def caveats; <<-EOS.undent
    To configure, copy the default config to your HOME and edit it:
      cp #{prefix}/todo.cfg ~/.todo.cfg
    EOS
  end
end
