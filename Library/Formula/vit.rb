class Vit < Formula
  desc "Front-end for Task Warrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  head "https://git.tasktools.org/scm/ex/vit.git"
  url "https://taskwarrior.org/download/vit-1.2.tar.gz"
  sha256 "a78dee573130c8d6bc92cf60fafac0abc78dd2109acfba587cb0ae202ea5bbd0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "148f01bcfe731892cbfbc63eb9e8d95fded12f07c2d56a7429f8ddea27207f51" => :el_capitan
    sha256 "e91023aac9f44f67570d248255fc61ed614091fdfafb16003b49064d90866d91" => :yosemite
    sha256 "3f7e65dd15708aaf63ed1d3d3bc948cd020371b35c4537a1366d34a94181767e" => :mavericks
  end

  depends_on "task"

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.31.tgz"
    sha256 "7bb4623ac97125c85e25f9fbf980103da7ca51c029f704f0aa129b7a2e50a27a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("Curses").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "build"

    bin.install "vit"
    man1.install "vit.1"
    man5.install "vitrc.5"
    # vit-commands needs to be installed in the keg because that's where vit
    # will look for it.
    (prefix+"etc").install "commands" => "vit-commands"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
