class Sslmate < Formula
  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.5.1.tar.gz"
  sha256 "533d05e483d06460876916bfe2a9b33be4e8b6212b1f46e96ab4dc9e8e87c660"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a6eee4531f266aee87c4aefb08fb3502a34b0d456e10321cff709e63f418f43" => :el_capitan
    sha256 "96bb8413c6470f541f915990db5fe2f0af4aa090e222f72f7fc742cced366379" => :yosemite
    sha256 "82bb8875b57ec02333edf569e9a1634c688c82238c3831e25d94029178868856" => :mavericks
  end

  option "without-route53", "Disable support for Route 53 DNS approval"

  if MacOS.version <= :snow_leopard
    depends_on "perl"
    depends_on "curl"

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/URI-1.67.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/E/ET/ETHER/URI-1.67.tar.gz"
      sha256 "ab7f5fbc80da4ed9c46d63ed956c68a09e83dae30f20c2778c3e056d41883f9d"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/J/JS/JSTOWE/TermReadKey-2.32.tar.gz"
      sha256 "58b90e8908e686d03a161590c1dd870e8a1b005715ca8e6d5080a32459e1e9f8"
    end
  end

  if MacOS.version <= :mountain_lion
    resource "JSON::PP" do
      url "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
      mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27300.tar.gz"
      sha256 "5feef3067be4acd99ca0ebb29cf1ac1cdb338fe46977585bd1e473ea4bab71a3"
    end
  end

  if build.with? "route53"
    depends_on :python if MacOS.version <= :snow_leopard

    resource "boto" do
      url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
      sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
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
