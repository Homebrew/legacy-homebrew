class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/3.0.0.tar.gz"
  sha256 "490742428824d6e807e894c3b6612be37a9a9a4e8fbea747d1813e5d62b2a807"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "518782b4a797275a9ea54a01956f15fa166bdd68398c26d5a890948f4306dc98" => :el_capitan
    sha256 "3eabd97b6e574274665ed178b72076648ed03da53c7dd29425835331592c3378" => :yosemite
    sha256 "14471fe41a1162813ed803fe9edc91aca493d7529340e8f15e2cea9aa269d586" => :mavericks
    sha256 "7655c7e7f926d58b28a8ef503b406ff2c0f6fb2102a2915cb7d05b36b26f9d9b" => :mountain_lion
  end

  def install
    inreplace "Makefile", %r{\$\(DESTDIR\)(?=/etc/bash_completion\.d)}, "$(DESTDIR)$(PREFIX)"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    assert_match /#{testpath}/, shell_output("#{bin}/git-root")
  end
end
