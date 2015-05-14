class Sslmate < Formula
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.1.1.tar.gz"
  sha256 "019eb13200ab6a4a0cf2cef6c022928c3eaace767951f37dd80e1ad92ebf30ef"

  bottle do
    cellar :any
    sha256 "69660457af355c53fba98283b3b72bdbb0e3c919e3e330454004ca7833845e27" => :yosemite
    sha256 "7682d82301ffcda80b861b50977c1bd952915109a812508e8c0a3d66353c8acc" => :mavericks
    sha256 "799696962067c31cb41527cf259dea5c43e8e64431c2e10373599c7e79c40b21" => :mountain_lion
  end

  option "without-route53", "Disable support for Route 53 DNS approval"

  if MacOS.version <= :snow_leopard
    depends_on "perl"
    depends_on "curl"

    resource "URI" do
      url "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.64.tar.gz"
      mirror "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.64.tar.gz"
      sha256 "ab7f5fbc80da4ed9c46d63ed956c68a09e83dae30f20c2778c3e056d41883f9d"
    end

    resource "Term::ReadKey" do
      url "http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
      mirror "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
      sha256 "58b90e8908e686d03a161590c1dd870e8a1b005715ca8e6d5080a32459e1e9f8"
    end
  end

  if MacOS.version <= :mountain_lion
    resource "JSON::PP" do
      url "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
      mirror "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
      sha256 "5feef3067be4acd99ca0ebb29cf1ac1cdb338fe46977585bd1e473ea4bab71a3"
    end
  end

  if build.with? "route53"
    depends_on :python if MacOS.version <= :snow_leopard

    resource "boto" do
      url "https://pypi.python.org/packages/source/b/boto/boto-2.34.0.tar.gz"
      sha256 "33baab022ecb803414ad0d6cf4041d010cfc2755ff8acc3bea7b32e77ba98be0"
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
