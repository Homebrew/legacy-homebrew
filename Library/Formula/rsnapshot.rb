class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "http://rsnapshot.org"
  url "http://rsnapshot.org/downloads/rsnapshot-1.4.0.tar.gz"
  sha256 "222574fee2f59d0e3ef5da6e6dd0f445205fecfa7ca12ef821eb8a89cf4f2ca8"

  head "https://github.com/DrHyde/rsnapshot.git"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
