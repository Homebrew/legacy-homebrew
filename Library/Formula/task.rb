class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"

  stable do
    url "https://taskwarrior.org/download/task-2.4.4.tar.gz"
    sha256 "7ff406414e0be480f91981831507ac255297aab33d8246f98dbfd2b1b2df8e3b"

    depends_on "gnutls" => :optional
  end

  bottle do
    revision 1
    sha256 "f32ef8aafe33589609712f0d5440132ccb4a4e491736bfa493434ffef6bbf3d4" => :el_capitan
    sha256 "b192c1ca2c8565c98de6afed5d597f51766144ca7ccbf258b8acdbdb2e6238b7" => :yosemite
    sha256 "0e06847ebc7af012af157ed90129c632a60eec6c335f0d05feeafb9793ec874b" => :mavericks
  end

  devel do
    url "http://taskwarrior.org/download/task-2.5.0.beta3.tar.gz"
    sha256 "ed41e7d4344da57b6cbc24971e7ddba08486f54e8030779f2ebd939086e11bc8"
    version "2.5.0.beta3"

    depends_on "gnutls"
  end

  head do
    url "https://git.tasktools.org/scm/tm/task.git", :branch => "2.5.0", :shallow => false

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
