class Moreutils < Formula
  homepage "http://joeyh.name/code/moreutils/"
  url "http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.52.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.52.tar.gz"
  sha1 "32047f935178b490a12c370d8f695f1273dc5895"

  bottle do
    revision 2
    sha1 "09c41223be308962ffb8014fdbcedba9c9288a8c" => :yosemite
    sha1 "07383e8aa340c226800d36fb0d2107073c05392d" => :mavericks
    sha1 "7ed2b97a47512e47e7a74ee11ebf8b3cc5d1697e" => :mountain_lion
  end

  depends_on "docbook-xsl" => :build

  option "without-parallel", "Omit the 'parallel' tool. Allows installation of GNU parallel from 'parallel' formula."

  if build.with? "parallel"
    conflicts_with "parallel",
      :because => "both install a 'parallel' executable. See the '--without-parallel' option"
  end

  conflicts_with 'task-spooler',
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
    pipe_output("#{bin}/isutf8", "hello")
    assert $?.success?
    pipe_output("#{bin}/isutf8", "\xca\xc0\xbd\xe7")
    assert (!$?.success?)
  end
end
