class Task < Formula
  homepage "http://www.taskwarrior.org/"
  url "http://taskwarrior.org/download/task-2.4.3.tar.gz"
  sha1 "2a0c1519b1b572c91f8d6ee489b1250a993a3e86"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.4.4", :shallow => false

  bottle do
    sha256 "8fe979d6645f9695daa55fda3ac068d2aa624c871def1c4423d91bf19f39c619" => :yosemite
    sha256 "b7c0fd1dad5721a38189d5ed29866579312316a51a1d423b6fad091c38478739" => :mavericks
    sha256 "498277be998aa4042c47fe3c1f4c9ab3291e946389aae52daa60bbde25d9cb1f" => :mountain_lion
  end

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
