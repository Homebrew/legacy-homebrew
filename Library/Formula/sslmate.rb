require "formula"

class Sslmate < Formula
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.0.0.tar.gz"
  sha256 "87fbbaeb38d07d5732533b9391846e7e55e0f1f3766d0ef7919f0d22840df71e"

  bottle do
    cellar :any
    sha256 "180aa500c33b5d7ecc951b1dc7a319f8679630d2d3b5f99aeb15645568075bff" => :yosemite
    sha256 "3bdad9e0e103af6a3a0177a9407abec6eec7bba234425b493d1c2ddd6bcd972b" => :mavericks
    sha256 "5bdf1a73b66e6456aa8aaaf3f8cc88213f795122d0e12ad02228029261417803" => :mountain_lion
  end

  option "without-route53", "Disable support for Route 53 DNS approval"

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

  if build.with? "route53"
    depends_on :python if MacOS.version <= :snow_leopard

    resource "boto" do
      url "https://pypi.python.org/packages/source/b/boto/boto-2.34.0.tar.gz"
      sha1 "e19d252b58054a7711fae910324e26b2b551a44d"
    end
  end

  def install
    if MacOS.version <= :snow_leopard
      ENV.prepend_path "PATH", Formula["perl"].bin
    end
    ENV.prepend_create_path "PERL5LIB", libexec + "vendor/lib/perl5"
    ENV.prepend_create_path "PYTHONPATH", libexec + "vendor/lib/python2.7/site-packages" if build.with? "route53"

    perl_resources = []
    perl_resources << "URI" << "Term::ReadKey" if MacOS.version <= :snow_leopard
    perl_resources << "JSON::PP" if MacOS.version <= :mountain_lion
    perl_resources.each do |r|
      resource(r).stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/vendor"
        system "make"
        system "make", "install"
      end
    end

    python_resources = []
    python_resources << "boto" if build.with? "route53"
    python_resources.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec + "vendor")
      end
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    env = { :PERL5LIB => ENV["PERL5LIB"] }
    if MacOS.version <= :snow_leopard
      env[:PATH] = "#{Formula["perl"].bin}:#{Formula["curl"].bin}:$PATH"
    end
    env[:PYTHONPATH] = ENV["PYTHONPATH"] if build.with? "route53"
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
