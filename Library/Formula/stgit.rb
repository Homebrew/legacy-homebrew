class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://gna.org/projects/stgit/"
  url "http://download.gna.org/stgit/stgit-0.17.1.tar.gz"
  sha256 "d43365a0c22e41a6fb9ba1a86de164d6475e79054e7f33805d6a829eb4056ade"

  head "git://repo.or.cz/stgit.git"

  def install
    ENV["PYTHON"] = "python" # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "log"
  end
end
