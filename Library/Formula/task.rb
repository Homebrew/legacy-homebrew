require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.1.0.tar.gz'
  sha1 'fd1120db56bf44e0d84191d5dce29a6d9d872a8a'

  depends_on "cmake" => :build

  skip_clean :all

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    (etc+'bash_completion.d').install 'scripts/bash/task.sh'
    (share+'zsh/site-functions').install   'scripts/zsh/_task'
  end

  def caveats; <<-EOS.undent
    Bash completion has been installed to:
      #{etc}/bash_completion.d

    zsh completion has been installed to:
      #{HOMEBREW_PREFIX}/share/zsh/site-functions
    EOS
  end
end
