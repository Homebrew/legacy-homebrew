require 'formula'

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.0.0.tar.gz'
  sha1 'dc587363fbdc1dcac7f7e07b1bccfd1fb56b2435'

  depends_on "cmake" => :build

  skip_clean :all

  def install
    system "cmake #{std_cmake_parameters}"
    system "make install"
    (etc+'bash_completion.d').install 'scripts/bash/task_completion.sh'
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
