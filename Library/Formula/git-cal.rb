class GitCal < Formula
  desc "GitHub-like contributions calendar but on the command-line"
  homepage "https://github.com/k4rthik/git-cal"
  url "https://github.com/k4rthik/git-cal/archive/v0.9.1.tar.gz"
  sha256 "783fa73197b349a51d90670480a750b063c97e5779a5231fe046315af0a946cd"

  head "https://github.com/k4rthik/git-cal.git"

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # git-cal fails when run outside of a git repo.
    HOMEBREW_REPOSITORY.cd do
      system "#{bin}/git-cal"
    end
  end
end
