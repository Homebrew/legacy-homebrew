class Mdp < Formula
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/0.93.0.tar.gz"
  sha1 "5e267c8d9d3c2b30bd1951e854f1d4ad7c8679cf"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any
    sha1 "0df708dbbf816fe3d2430047e3e98908044b9ead" => :yosemite
    sha1 "63260949aeaa48d1e41dfb3d682e7c894b5d26a6" => :mavericks
    sha1 "72f8255820f988a26be93b40a9f8256ace349892" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    share.install "sample.md"
  end

  test do
    # Go through two slides and quit.
    ENV["TERM"] = "xterm"
    pipe_output "#{bin}/mdp #{share}/sample.md", "jjq", 0
  end
end
