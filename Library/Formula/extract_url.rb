class ExtractUrl < Formula
  desc "Perl script to extracts URLs from emails or plain text."
  homepage "http://www.memoryhole.net/~kyle/extract_url/"
  url "https://github.com/m3m0ryh0l3/extracturl/archive/v1.6.tar.gz"
  sha256 "2f8fb4c361a02ee0053d2e1791d283e9b202297e4b861d7ff676ac00438ddcaf"

  bottle do
    cellar :any_skip_relocation
    sha256 "798e74f8b8f742ac15f99086a6491e5958316461a2d3a664f8a405f23a4ea938" => :el_capitan
    sha256 "76b29261c92fd1d0b0575f91c0dec7d0142465097593f96882fa34be9e48b90f" => :yosemite
    sha256 "55c1a2bd5b6f71eadaf2eba18623268b87e7019a25dd670077f90cd7ccbd032a" => :mavericks
    sha256 "2bfe029ac91f5cfa70440ed9b65f7996fd7e199d5f286bd4c5958757b79d0909" => :mountain_lion
  end

  resource "MIME::Parser" do
    url "https://cpan.metacpan.org/authors/id/D/DS/DSKOLL/MIME-tools-5.506.tar.gz"
    sha256 "dbed9bf46830c4a1df9840a546824ee44d14902012870f0c34bc4f5cc86af812"
  end

  resource "HTML::Parser" do
    url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTML-Parser-3.71.tar.gz"
    sha256 "be918b3749d3ff93627f72ee4b825683332ecb4c81c67a3a8d72b0435ffbd802"
  end

  resource "Pod::Usage" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAREKR/Pod-Usage-1.67.tar.gz"
    sha256 "c8be6d29b0dfe304c4ddfcc140f93d4c4de7a8362ea6e2651611c288b53cc68a"
  end

  resource "Env" do
    url "https://cpan.metacpan.org/authors/id/F/FL/FLORA/Env-1.04.tar.gz"
    sha256 "d94a3d412df246afdc31a2199cbd8ae915167a3f4684f7b7014ce1200251ebb0"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.47.tar.gz"
    sha256 "f5e6633ccda3f56a2df7a29f4187f4c787be4b746d97e9eb4aabd3aec1d9ed7b"
  end

  resource "URI::Find" do
    url "https://cpan.metacpan.org/authors/id/M/MS/MSCHWERN/URI-Find-20140709.tar.gz"
    sha256 "c0c34c5f7eddacc1c6553099015fe776797f1ec5a70e11e6e8fa68810224ec33"
  end

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.32.tgz"
    sha256 "5dba44fd7964806d9765e6692bc7eb8eb30aeced2740f28b9a4070a5d14ba650"
  end

  resource "Curses::UI" do
    url "https://cpan.metacpan.org/authors/id/M/MD/MDXI/Curses-UI-0.9609.tar.gz"
    sha256 "0ab827a513b6e14403184fb065a8ea1d2ebda122d2178cbf45c781f311240eaf"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    %w[MIME::Parser HTML::Parser Pod::Usage Env Getopt::Long Curses Curses::UI].each do |r|
      resource(r).stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    resource("URI::Find").stage do
      system "perl", "Build.PL", "--install_base", libexec
      system "./Build"
      system "./Build", "install"
    end

    system "make", "man"

    libexec.install "extract_url.pl"
    chmod 0755, libexec/"extract_url.pl"
    (bin/"extract_url").write_env_script("#{libexec}/extract_url.pl", :PERL5LIB => ENV["PERL5LIB"])
    man1.install "extract_url.1"
  end

  test do
    (testpath/"test.txt").write("Hello World!\nhttps://www.google.com\nFoo Bar")
    assert_match "https://www.google.com", pipe_output("#{bin}/extract_url -l test.txt")
  end
end
