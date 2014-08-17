require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.51.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.51.tar.gz'
  sha1 '374b8c3bea962bbcde4a8158051c570a1fec6811'

  bottle do
    cellar :any
    sha1 "21fa332179c54179b9581ec1fd5eae00eefbf9da" => :mavericks
    sha1 "b7b88be54b3cd5659a720dd899ceacd790414e20" => :mountain_lion
    sha1 "f873a5e0b83b859899c98126871d0fa4bb04b8b9" => :lion
  end

  depends_on "docbook-xsl" => :build

  conflicts_with 'parallel',
    :because => "both install a 'parallel' executable."

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
    system "make", "all"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
