class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "http://taskwarrior.org/projects/show/taskwarrior"
  url "http://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"

  head "https://git.tasktools.org/scm/tm/taskd.git"

  bottle do
    sha256 "c909bc5cd6d837849a4c0bc4f3da7eccc615273eb4cf5bbc57a3910f6d550710" => :yosemite
    sha256 "83c100be045d37465a822be0e52bd3748b36219bacc9f628e5f03ecf86f809b8" => :mavericks
    sha256 "9249bbdb208074b8a799096c626e2a87f02be732befe828315c352f4297283b6" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/taskd", "init", "--data", testpath
  end
end
