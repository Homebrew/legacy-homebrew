class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.57.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/moreutils/moreutils_0.57.orig.tar.gz"
  sha256 "3a7d54b0634e5eda8c3c43490d47cea189156700892dea6d876867cef9bc0d1d"

  head "git://git.kitenet.net/moreutils"

  bottle do
    cellar :any_skip_relocation
    sha256 "5475ea829217bd88b5a9bd1a0b71615dccd092aeaddec2b499fc725c58b48074" => :el_capitan
    sha256 "abbe3897f14ef314900fb165e76de97bd7a948cded5b26f3c2471f50adfd2f11" => :yosemite
    sha256 "ec107c6a7c081c5e990c9b79eb3fde8cb6c9ac4e8e0c52de8f751b624927861a" => :mavericks
    sha256 "d506ebb771c12c334e5597bb57b751c3ad738ca38aaf5cb00f88b7b25f6a776c" => :mountain_lion
  end

  option "without-parallel", "Build without the 'parallel' tool."

  depends_on "docbook-xsl" => :build

  conflicts_with "parallel", :because => "Both install a 'parallel' executable."
  conflicts_with "task-spooler", :because => "Both install a 'ts' executable."

  resource "Time::Duration" do
    url "http://search.cpan.org/CPAN/authors/id/A/AV/AVIF/Time-Duration-1.1.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/A/AV/AVIF/Time-Duration-1.1.tar.gz"
    sha256 "a69c419c4892f21eba10002e2ab8c55b657b6691cf6873544ef99ef5fd188f4e"
  end

  resource "IPC::Run" do
    url "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz"
    sha256 "e186b46ddf1577d24f11eec1ba42285963c3f71ec7ecb1ce51d6e88c729d46d2"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("Time::Duration").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "--skipdeps"
      system "make", "install"
    end

    resource("IPC::Run").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    inreplace "Makefile",
              "/usr/share/xml/docbook/stylesheet/docbook-xsl",
              "#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    if build.without? "parallel"
      inreplace "Makefile", /^BINS=.*\Kparallel/, ""
      inreplace "Makefile", /^MANS=.*\Kparallel\.1/, ""
    end
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    pipe_output("#{bin}/isutf8", "hello", 0)
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7", 1)
  end
end
