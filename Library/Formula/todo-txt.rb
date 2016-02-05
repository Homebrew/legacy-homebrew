class TodoTxt < Formula
  desc "Minimal, todo.txt-focused editor"
  homepage "http://todotxt.com/"
  url "https://github.com/ginatrapani/todo.txt-cli/releases/download/v2.10/todo.txt_cli-2.10.tar.gz"
  sha256 "b59417a26feeafd811e0f1ff17e85e69ac5bcb1a0544b736f539ffb8fe27f6a9"
  head "https://github.com/ginatrapani/todo.txt-cli.git"

  bottle :unneeded

  def install
    bin.install "todo.sh"
    prefix.install "todo.cfg" # Default config file
    bash_completion.install "todo_completion"
  end

  def caveats; <<-EOS.undent
    To configure, copy the default config to your HOME and edit it:
      cp #{prefix}/todo.cfg ~/.todo.cfg
    EOS
  end

  test do
    cp prefix/"todo.cfg", testpath/".todo.cfg"
    inreplace testpath/".todo.cfg", "export TODO_DIR=$(dirname \"$0\")", "export TODO_DIR=#{testpath}"
    system bin/"todo.sh", "add", "Hello World!"
    system bin/"todo.sh", "list"
  end
end
