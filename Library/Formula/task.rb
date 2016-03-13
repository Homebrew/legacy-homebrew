class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"

  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.6.0", :shallow => false

  bottle do
    sha256 "eb3dc1497ed1c6701a12714fa7e5b1a8732aebce516263d15386b1cfcc5ed790" => :el_capitan
    sha256 "87d6a510df37189e80ce12724b8e390ccb88d949c2d2099453d41b4e99c281c1" => :yosemite
    sha256 "274a7ecc28e5843d057e4e4c51f90856fb487fb78b990e36758e12dcd5fa4303" => :mavericks
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
