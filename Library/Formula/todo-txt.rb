require 'formula'

class TodoTxt < Formula
  url 'https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.8.tar.gz'
  homepage 'http://todotxt.com/'
  md5 '065b848d0c300dd024a4ece86a68c0fa'
  head 'https://github.com/ginatrapani/todo.txt-cli.git'

  def install
    bin.install 'todo.sh'
    prefix.install 'todo.cfg' # Default config file
  end

  def caveats; <<-EOS.undent
    To configure, copy the default config to your home and edit it:
      cp #{prefix}/todo.cfg ~/.todo.cfg
    EOS
  end
end
