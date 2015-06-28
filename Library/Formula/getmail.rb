class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-4.48.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/getmail4/getmail4_4.48.0.orig.tar.gz"
  sha256 "49441e92eed577127331caf9b97f2ddaea14e97e8a49259efd9184a766a9b94c"

  # See: https://github.com/Homebrew/homebrew/pull/28739
  patch do
    url "https://gist.githubusercontent.com/sigma/11295734/raw/5a7f39d600fc20d7605d3c9e438257285700b32b/ssl_timeout.patch"
    sha256 "cd5efe16c848c14b8db91780bf4e08a5920f6576cc68628b0941aa81857f4e2f"
  end

  def install
    libexec.install %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install "getmailcore"
    man1.install Dir["docs/*.1"]
  end

  test do
    system bin/"getmail", "--help"
  end
end
