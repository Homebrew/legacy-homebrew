class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.0.tar.gz"
  sha256 "4d8e67415a6993108c11b8eeef99b76a991af11b22874adbb7ae367e09334636"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.5.1", :shallow => false

  bottle do
    revision 1
    sha256 "b5215c6498e14ce80811d34ffcdeb0097e5ffe699f4bd93bc845e12cf9df3aa4" => :el_capitan
    sha256 "026ac81ac65d3c34e7345e72d80c756521cfda7e19bb5148a7608bdab274d0ef" => :yosemite
    sha256 "8651183eacf5d5c23a84d3593a67fb24a0dae92c03b6664d03ee0952b5eb6ae4" => :mavericks
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
