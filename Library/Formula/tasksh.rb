class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.0.0.tar.gz"
  head "https://git.tasktools.org/scm/ex/tasksh.git"
  sha256 "9accc81f5ae3a985e33be728d56aba0401889d21f856cd94734d73c221bf8652"

  bottle do
    cellar :any
    sha256 "736e3e4e70b6d1c6b56727dafeebf55b6c188ee298cf303c906d4e129ad1054a" => :yosemite
    sha256 "87a3ca027b877fb67546c9b2277112c34051cf2da7ae62b7c9704289ceef4fdb" => :mavericks
    sha256 "589fc472082ab7486c4b7b5d6348ea6a8dc5fac39ba3544b51dd8fd55f37aa9c" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "task" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert pipe_output("#{bin}/tasksh", "add Test Task").include?("Created task")
  end
end
