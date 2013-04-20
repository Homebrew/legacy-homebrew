require 'formula'

class GitFtp < Formula
  homepage 'https://github.com/git-ftp/git-ftp'
  url 'https://github.com/git-ftp/git-ftp/archive/0.8.4.tar.gz'
  sha1 '77b615993d0095ad700e6ee6d82ef4005e5e2269'

  head 'https://github.com/git-ftp/git-ftp.git'

  depends_on 'git'
  depends_on 'curl' => %w{with-ssl with-ssh}
  depends_on 'grep' => 'default-names'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
