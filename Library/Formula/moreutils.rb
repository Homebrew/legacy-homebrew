class Moreutils < Formula
  desc "Collection of tools that nobody wrote when UNIX was young"
  homepage "http://joeyh.name/code/moreutils/"
  url "https://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.55.orig.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.55.orig.tar.gz"
  sha1 "050c73067d2b5373f2652b91e75699dd79a44590"

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
    mirror "http://search.mcpan.org/CPAN/authors/id/A/AV/AVIF/Time-Duration-1.1.tar.gz"
    sha1 "5acc5013d8b4ab52416555e1f08546a8d8a3fb41"
  end

  resource "IPC::Run" do
    url "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz"
    sha1 "87e0c796722a85e0908bb0224326af1436d35809"
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
