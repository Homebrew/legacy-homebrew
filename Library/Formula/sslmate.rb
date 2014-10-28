require "formula"

class Sslmate < Formula
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-0.4.5.tar.gz"
  sha256 "1791eab553f763d92f28027fda5a04afdf8b3ef24c3e32cfe98441a68470b138"

  depends_on "perl" if MacOS.version <= :snow_leopard
  depends_on "curl" if MacOS.version <= :snow_leopard

  resource "URI" do
    url "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.64.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.64.tar.gz"
    sha1 "80b43be09119f65f87ac3ab947c1e1cf0e0d0a8a"
  end if MacOS.version <= :snow_leopard

  resource "Term::ReadKey" do
    url "http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
    sha1 "0aef1009fca526d3a2ee4336584ff4cd69c2396e"
  end if MacOS.version <= :snow_leopard

  resource "JSON::PP" do
    url "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
    sha1 "21aea2dbed9507b9f62c5748893fc5431c715754"
  end if MacOS.version <= :mountain_lion

  def install
    if MacOS.version <= :snow_leopard
      ENV.prepend_path "PATH", Formula["perl"].bin
    end
    ENV.prepend_create_path "PERL5LIB", libexec + "lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    bin.install "bin/sslmate"
    doc.install "README", "NEWS"
    man1.install "man/man1/sslmate.1"
    if MacOS.version <= :snow_leopard
      # Make sure to use Perl and Curl from the Cellar, rather than the system:
      bin.env_script_all_files(libexec + "bin", :PERL5LIB => ENV["PERL5LIB"],
              :PATH => "#{Formula["perl"].bin}:#{Formula["curl"].bin}:$PATH")
    else
      bin.env_script_all_files(libexec + "bin", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    system "#{bin}/sslmate", "req", "www.example.com"
    # Make sure well-formed files were generated:
    system "openssl", "rsa", "-in", "www.example.com.key", "-noout"
    system "openssl", "req", "-in", "www.example.com.csr", "-noout"
    # The version command tests the HTTP client:
    system "#{bin}/sslmate", "version"
  end
end
