class Hilite < Formula
  desc "CLI tool that runs a command and highlights STDERR output"
  homepage "https://sourceforge.net/projects/hilite/"
  url "https://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c"
  sha256 "e15bdff2605e8d23832d6828a62194ca26dedab691c9d75df2877468c2f6aaeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c407d12952089ade6602be85acda46eceb3127e32ba2068c0034df8a486e989" => :el_capitan
    sha256 "1eea4240f83568d245aa55801949cd9deb4663fc26df75569e029cc1c4c14112" => :yosemite
    sha256 "d004176bb8c9df0a165c05863d594e007831cc6b9ce4219ec3639b4ba1069895" => :mavericks
  end

  def install
    system "#{ENV.cc} #{ENV.cflags} hilite.c -o hilite"
    bin.install "hilite"
  end

  test do
    system "#{bin}/hilite", "bash", "-c", "echo 'stderr in red' >&2"
  end
end
