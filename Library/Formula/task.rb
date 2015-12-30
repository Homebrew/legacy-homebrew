class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.0.tar.gz"
  sha256 "4d8e67415a6993108c11b8eeef99b76a991af11b22874adbb7ae367e09334636"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.5.1", :shallow => false

  bottle do
    revision 2
    sha256 "fc6d7d516179dbf8d16768e8d003017c7ae4e28de6e01fb72231f54d0ac91eb3" => :el_capitan
    sha256 "6fb193925ef9ac04569d715062fc6f650ff5575a873ad73d45abbabca40d2bc5" => :yosemite
    sha256 "91fae7d81bb7befc6d1637ab72b928ee753dd073f0d61aada6f5f9f959a6c04f" => :mavericks
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
