require "formula"

class Getmail < Formula
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-4.46.0.tar.gz"
  mirror "http://fossies.org/linux/misc/getmail-4.46.0.tar.gz"
  sha1 "0e20fcfed6c422e5135304c3728c11c7cee7081a"

  # See: https://github.com/Homebrew/homebrew/pull/28739
  patch do
    url "https://gist.githubusercontent.com/sigma/11295734/raw/5a7f39d600fc20d7605d3c9e438257285700b32b/ssl_timeout.patch"
    sha1 "d7242a07c0d4de1890bb8ebd51b55e01e859b302"
  end

  def install
    libexec.install %w( getmail getmail_fetch getmail_maildir getmail_mbox )
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install "getmailcore"
    man1.install Dir["docs/*.1"]
  end
end
