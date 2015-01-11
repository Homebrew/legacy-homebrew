class Task < Formula
  homepage "http://www.taskwarrior.org/"
  url "http://www.taskwarrior.org/download/task-2.4.0.tar.gz"
  sha1 "2c01e3eb874e7e499d31c99f93a37925b2f60ce8"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.4.1", :shallow => false

  depends_on "cmake" => :build
  depends_on "gnutls" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
  end

  test do
    system "#{bin}/task", "--version"
  end
end
