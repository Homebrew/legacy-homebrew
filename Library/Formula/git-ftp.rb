class GitFtp < Formula
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.0.2.tar.gz"
  sha256 "f488c39bf7784923201c61ece41f40f8e18682e18b13918b0730ad196a11f1f7"

  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha1 "a50d3779a05f20c022634e521dbac54db3cb8bba" => :yosemite
    sha1 "9ecb3e11463fb1ec6d961747e24be242fc8213ea" => :mavericks
    sha1 "90bd8f913a3c01f8cdc55d77dd8ed455354bfa52" => :mountain_lion
  end

  option "with-manpage", "build and install the manpage (depends on pandoc)"

  depends_on "curl" => "with-libssh2"
  depends_on "pandoc" => :build if build.with? "manpage"

  def install
    system "make", "prefix=#{prefix}", "install"
    if build.with? "manpage"
      system "make", "-C", "man", "man"
      man1.install "man/man1/git-ftp.1"
    end
    libexec.install bin/"git-ftp"
    (bin/"git-ftp").write <<-EOS.undent
      #!/bin/sh
      PATH=#{Formula["curl"].opt_bin}:$PATH
      #{libexec}/git-ftp "$@"
    EOS
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
