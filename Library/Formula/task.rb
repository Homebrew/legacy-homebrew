class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"

  stable do
    url "https://taskwarrior.org/download/task-2.5.0.tar.gz"
    sha256 "4d8e67415a6993108c11b8eeef99b76a991af11b22874adbb7ae367e09334636"
  end

  bottle do
    sha256 "a2f68eb1bd6ff5f0992603c64faff6788e862ed943b5a0b7104a1969a4dc9c1a" => :el_capitan
    sha256 "bbf344c831fe72587ba3673c41b49433c8078bf93054dbed1ce9fac6edce5146" => :yosemite
    sha256 "598d16065ecdd17a628764e47e93bb0309dcbc41ff6f689c046519c5a7e5c0f8" => :mavericks
  end

  head do
    url "https://git.tasktools.org/scm/tm/task.git", :branch => "2.5.1", :shallow => false
  end

  option "without-gnutls", "Don't use gnutls; disables sync support"

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended

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
