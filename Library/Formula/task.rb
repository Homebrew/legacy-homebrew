require 'formula'

class TaskwarriorDownloadStrategy < GitDownloadStrategy
  # CMakeLists.txt requires presence of .git to generate commit.h
  # (version information), otherwise make fails.
  def support_depth?
    false
  end
end

class Task < Formula
  homepage 'http://www.taskwarrior.org/'
  url 'http://www.taskwarrior.org/download/task-2.2.0.tar.gz'
  sha1 '70656deb48a460f95370c885e388b475475f64eb'
  head 'git://tasktools.org/task.git', :branch => :"2.3.0",
                                       :using => TaskwarriorDownloadStrategy

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    bash_completion.install 'scripts/bash/task.sh'
    zsh_completion.install 'scripts/zsh/_task'
  end

  test do
    system "#{bin}/task", "--version"
  end
end
