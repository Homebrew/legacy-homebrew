class GitCal < Formula
  desc "GitHub-like contributions calendar but on the command-line"
  homepage "https://github.com/k4rthik/git-cal"
  url "https://github.com/k4rthik/git-cal/archive/v0.9.1.tar.gz"
  sha256 "783fa73197b349a51d90670480a750b063c97e5779a5231fe046315af0a946cd"

  head "https://github.com/k4rthik/git-cal.git"

  bottle do
    sha256 "0ceb50d8f6038f54709422700ca0347e5758880b3256193059fef826c02370ea" => :yosemite
    sha256 "06054ffa5848f289225e3bcd9978bfcfd1238e0e0de5a060b4c680a66b44fa51" => :mavericks
    sha256 "7d6308aa47d99e203173fa12896f24bb11b9a9aba91c89de9199fed0a1f6db74" => :mountain_lion
  end

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
