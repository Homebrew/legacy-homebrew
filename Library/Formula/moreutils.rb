class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "http://joeyh.name/code/moreutils/"
  url "https://distfiles.macports.org/moreutils/moreutils_0.55.orig.tar.gz"
  sha256 "da9d5cd145ceea967a65dd50031d168d66199c3eb41b9390b57f35d4a5808ab5"

  bottle do
    sha1 "a7d3974c453e9b68d0254505f5bb4ed9fa9ba3a3" => :yosemite
    sha1 "314304205f3f69f2a885524ea327ddb887be43d9" => :mavericks
    sha1 "47ac9f9d22e0890e9df62e602ecf7a70a378826f" => :mountain_lion
  end

  depends_on "docbook-xsl" => :build

  option "without-parallel", "Omit the 'parallel' tool. Allows installation of GNU parallel from 'parallel' formula."

  if build.with? "parallel"
    conflicts_with "parallel",
      :because => "both install a 'parallel' executable. See the '--without-parallel' option"
  end

  conflicts_with "task-spooler",
    :because => "both install a 'ts' executable."

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
