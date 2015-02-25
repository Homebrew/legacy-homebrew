class Task < Formula
  homepage "http://www.taskwarrior.org/"
  url "http://taskwarrior.org/download/task-2.4.1.tar.gz"
  sha1 "4882628ac339e31fcb0fef2f4a1c585e86eb95c7"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.4.2", :shallow => false

  bottle do
    sha1 "1e92d7536061d35644a90a8e7ed8a2a711a38eee" => :yosemite
    sha1 "1281ae5d1ca0a6fb79ca844b8ff88ef3cb8a2519" => :mavericks
    sha1 "d8500859d28a14a5b22fa1f7b71ab6061df9a087" => :mountain_lion
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
