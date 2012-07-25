require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.1.1.tar.gz'
  sha1 'c23cb320f3478e37527c5c3cc547286f97bacc7c'

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
