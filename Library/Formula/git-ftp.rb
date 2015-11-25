class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.1.0.tar.gz"
  sha256 "b0de6dc36db506ac25a6fda21cb33d37b6a0b205fc72b0bd96de87359defc837"

  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab3dc523583810d2163ee293fed6f7af568367a8126130501df628a4b26072b7" => :el_capitan
    sha256 "578da024d360e191ad43bfeec951a05cf4d288f2ef98db3414149826c5c6728f" => :yosemite
    sha256 "586bdeba53fddbc4d708a315c5ad5f56356972b4250a964aaa8af79b3b619091" => :mavericks
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
