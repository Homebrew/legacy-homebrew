class Task < Formula
  homepage "http://www.taskwarrior.org/"
  url "http://taskwarrior.org/download/task-2.4.1.tar.gz"
  sha1 "4882628ac339e31fcb0fef2f4a1c585e86eb95c7"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.4.2", :shallow => false

  bottle do
    revision 1
    sha1 "acbdbada15ee3024b8678cc5bc962832de33047a" => :yosemite
    sha1 "4568d8cb2e9cef3ec533813ac156e5119dde4e07" => :mavericks
    sha1 "f391c3c7572f759ebcb389e37920000afe7eaf3f" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :optional
  depends_on "libuuid" unless OS.mac?

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
