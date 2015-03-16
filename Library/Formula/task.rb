class Task < Formula
  homepage "http://www.taskwarrior.org/"
  url "http://taskwarrior.org/download/task-2.4.2.tar.gz"
  sha1 "94699f518150e736e8d5ad2b5b7ccf8c988ed4d0"
  head "https://git.tasktools.org/scm/tm/task.git", :branch => "2.4.3", :shallow => false

  bottle do
    sha256 "d70d69485365a3b0a576df29a7ff00bc95dbe21824d37b97ae12facc2ac510c2" => :yosemite
    sha256 "4413f350853f5472e3c68da9edd7f0bd181366b09cdc1741708236ec5db5ee01" => :mavericks
    sha256 "dc0c41d326a30b0d7e4132680c10d0934f47d56e7c43f6ea1f428ac7e5538e91" => :mountain_lion
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
