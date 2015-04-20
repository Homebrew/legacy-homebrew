require "formula"

class Vit < Formula
  homepage "http://taskwarrior.org/news/news.20140406.html"
  head "https://git.tasktools.org/scm/ex/vit.git"
  url "http://taskwarrior.org/download/vit-1.2.tar.gz"
  sha1 "46ed3f9ff81112a2e28675720616568098a69cfa"
  revision 1

  depends_on "task"

  resource "Curses" do
    url "http://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.31.tgz"
    sha1 "9a70e8cd3d16c48fa8292608b8a5ca9e69976ded"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("Curses").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make build"

    bin.install "vit"
    man1.install "vit.1"
    man5.install "vitrc.5"
    # vit-commands needs to be installed in the keg because that's where vit
    # will look for it.
    (prefix+"etc").install "commands" => "vit-commands"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
