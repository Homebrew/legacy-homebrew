class Tasksh < Formula
  homepage "http://tasktools.org/projects/tasksh.html"
  url "http://taskwarrior.org/download/tasksh-1.0.0.tar.gz"
  head "https://git.tasktools.org/scm/ex/tasksh.git"
  sha256 "9accc81f5ae3a985e33be728d56aba0401889d21f856cd94734d73c221bf8652"

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
