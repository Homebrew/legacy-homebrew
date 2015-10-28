class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"

  stable do
    url "https://taskwarrior.org/download/task-2.5.0.tar.gz"
    sha256 "4d8e67415a6993108c11b8eeef99b76a991af11b22874adbb7ae367e09334636"

    depends_on "gnutls"
  end

  bottle do
    revision 1
    sha256 "f32ef8aafe33589609712f0d5440132ccb4a4e491736bfa493434ffef6bbf3d4" => :el_capitan
    sha256 "b192c1ca2c8565c98de6afed5d597f51766144ca7ccbf258b8acdbdb2e6238b7" => :yosemite
    sha256 "0e06847ebc7af012af157ed90129c632a60eec6c335f0d05feeafb9793ec874b" => :mavericks
  end

  head do
    url "https://git.tasktools.org/scm/tm/task.git", :branch => "2.5.1", :shallow => false

    depends_on "gnutls"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
