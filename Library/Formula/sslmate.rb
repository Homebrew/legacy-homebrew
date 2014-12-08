require "formula"

class Sslmate < Formula
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-0.6.1.tar.gz"
  sha256 "4c5ff4cdb3582a5264612c54469e360b6073cd16aed94018f7c8df12829bde05"

  bottle do
    cellar :any
    sha1 "07d3d55e911ca1647481f190853ca298f9dc3f8b" => :yosemite
    sha1 "276a08a659de01814259808834109b2be8550700" => :mavericks
    sha1 "2a2ff08dce30a4d7dd9ed511b26ab3f5e365914a" => :mountain_lion
  end

  if MacOS.version <= :snow_leopard
    depends_on "perl"
    depends_on "curl"

    resource "URI" do
      url "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.64.tar.gz"
      mirror "http://search.mcpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.64.tar.gz"
      sha1 "80b43be09119f65f87ac3ab947c1e1cf0e0d0a8a"
    end

    resource "Term::ReadKey" do
      url "http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
      mirror "http://search.mcpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
      sha1 "0aef1009fca526d3a2ee4336584ff4cd69c2396e"
    end
  end

  if MacOS.version <= :mountain_lion
    resource "JSON::PP" do
      url "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
      mirror "http://search.mcpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
      sha1 "21aea2dbed9507b9f62c5748893fc5431c715754"
    end
  end

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

    env = { :PERL5LIB => ENV["PERL5LIB"] }
    if MacOS.version <= :snow_leopard
      env[:PATH] = "#{Formula["perl"].bin}:#{Formula["curl"].bin}:$PATH"
    end
    bin.env_script_all_files(libexec + "bin", env)
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
