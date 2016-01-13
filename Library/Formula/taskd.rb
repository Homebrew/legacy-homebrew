class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/projects/show/taskwarrior"
  url "https://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  revision 1

  head "https://git.tasktools.org/scm/tm/taskd.git"

  bottle do
    revision 1
    sha256 "e2919a32b8be8a91e73091d811a596a6c6fc822ef1a5fbf05863afa09fe9593f" => :el_capitan
    sha256 "672663408ec30208beda96aeb909d02ae66035bd7b8ee3b64353b6d8c8857a31" => :yosemite
    sha256 "5f52342b12a6ffb79e67df90356fc9cb0797f384db65f1fa69b26a2e6229cbd2" => :mavericks
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
