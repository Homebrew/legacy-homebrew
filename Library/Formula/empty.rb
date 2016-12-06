class Empty < Formula
  desc "run processes under pseudo-terminal sessions"
  homepage "http://empty.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.20b/empty-0.6.20b.tgz"
  sha256 "7e6636e400856984c4405ce7bd0843aaa3329fa3efd20c58df8400a9eaa35f09"

  def install
    inreplace "Makefile", "man/man1", "share/man/man1"
    ENV.deparallelize
    args = %W[
      all
      install
      PREFIX=#{prefix}
    ]
    system "make", *args
  end

  test do
    system "#{bin}/empty"
  end
end
