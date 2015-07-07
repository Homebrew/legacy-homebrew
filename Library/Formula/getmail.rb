class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-4.48.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/getmail4/getmail4_4.48.0.orig.tar.gz"
  sha256 "49441e92eed577127331caf9b97f2ddaea14e97e8a49259efd9184a766a9b94c"

  bottle do
    cellar :any
    sha256 "d419e3a1ef926b9f9883497b58b0adf5e4d2abab5568028f180689405b6f8044" => :yosemite
    sha256 "525b3e87f0e39be465de58a425755800dc8c0cd00383c879008caa9ec4edc347" => :mavericks
    sha256 "3549cc78fb6723551dd3c69bff5ccc8f8830bb2fa5d6261a8218fb24435dbcaf" => :mountain_lion
  end

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
