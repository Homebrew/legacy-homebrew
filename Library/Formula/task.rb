class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"

  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.6.0", :shallow => false

  bottle do
    sha256 "07aa2c19ae6d7a9a46b286bfc48fa970aa9a9e0237e034bbaab354dcfc4f6848" => :el_capitan
    sha256 "113fc7ce057c51ea14021006a4106c25d29e361e4b70113e33fb7a83e57ee8d1" => :yosemite
    sha256 "7888e42210edb6691ff57d056585536abd318d62b43a898bb98e286373519164" => :mavericks
  end

  option "without-gnutls", "Don't use gnutls; disables sync support"

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended

  needs :cxx11

  def install
    args = std_cmake_args
    args << "-DENABLE_SYNC=OFF" if build.without? "gnutls"
    system "cmake", ".", *args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
