class Hilite < Formula
  desc "CLI tool that runs a command and highlights STDERR output"
  homepage "http://sourceforge.net/projects/hilite/"
  url "https://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c"
  sha256 "e15bdff2605e8d23832d6828a62194ca26dedab691c9d75df2877468c2f6aaeb"

  def install
    system "#{ENV.cc} #{ENV.cflags} hilite.c -o hilite"
    bin.install "hilite"
  end

  test do
    system "#{bin}/hilite", "bash", "-c", "echo 'stderr in red' >&2"
  end
end
