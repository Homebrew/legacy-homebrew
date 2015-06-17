class Man2html < Formula
  desc "Convert nroff man pages to HTML"
  homepage "http://dcssrv1.oit.uci.edu/indiv/ehood/man2html.html"
  url "http://dcssrv1.oit.uci.edu/indiv/ehood/tar/man2html3.0.1.tar.gz"
  sha256 "a3dd7fdd80785c14c2f5fa54a59bf93ca5f86f026612f68770a0507a3d4e5a29"

  def install
    bin.mkpath
    man1.mkpath
    system "/usr/bin/perl", "install.me", "-batch",
                            "-binpath", bin,
                            "-manpath", man
  end

  test do
    pipe_output("#{bin}/man2html", (man1/"man2html.1").read, 0)
  end
end
