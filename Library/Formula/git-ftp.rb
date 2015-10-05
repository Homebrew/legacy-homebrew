class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.0.2.tar.gz"
  sha256 "f488c39bf7784923201c61ece41f40f8e18682e18b13918b0730ad196a11f1f7"

  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9da54b0aebec317e6a9697e3902ad740270ec479d799be32c8b7e8a0b7f88e4e" => :el_capitan
    sha256 "28f1121cf94519c15eca06c48851c5385c8093bbd501162157a7adc0ed9eae57" => :yosemite
    sha256 "777c74d53098f88ca5a4b4202a7645e11361b567cace63b365b159660d5513de" => :mavericks
    sha256 "5a0ae43f9f07ce414c01a84862bc0b3eb9c508062c40b12a268d4fab2823d07a" => :mountain_lion
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
