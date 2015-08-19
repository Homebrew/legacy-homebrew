class Pgtap < Formula
  desc "Unit testing framework for PostgreSQL"
  homepage "http://pgtap.org/"
  url "http://api.pgxn.org/dist/pgtap/0.94.0/pgtap-0.94.0.zip"
  sha256 "c590ce9edb19a95dbd7caef84f677ff433fd87eaa68effdc4a7ac0fdf29be4cc"
  head "https://github.com/theory/pgtap.git"

  # Not :postgresql, because we need to install into its share directory.
  depends_on "postgresql"

  skip_clean "share"

  resource "Test::Harness" do
    url "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.30.tar.gz"
    sha256 "ff1900f3b3e61321d3c4b3283298f3106d43d55446605e9cfcf1dcec036acec1"
  end

  resource "TAP::Parser::SourceHandler::pgTAP" do
    url "http://cpan.metacpan.org/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.29.tar.gz"
    sha256 "918aa9ada7a05334ace7304e7b9e002bbf0b569bfcf8fb06118777bdabd60e1b"
  end

  def install
    # Make sure modules can find just-installed dependencies.
    arch  = `perl -MConfig -E 'print $Config{archname}'`
    plib  = "#{lib}/perl5"
    ENV["PERL5LIB"] = "#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"

    resource("Test::Harness").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
             "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
      system "make"
      system "make", "install"
    end

    resource("TAP::Parser::SourceHandler::pgTAP").stage do
      system "perl", "Build.PL", "--install_base", prefix, "--install_path",
             "bindoc=#{man1}", "--install_path", "libdoc=#{man3}"
      system "./Build"
      system "./Build", "install"
    end

    pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
    system "make", "PG_CONFIG=#{pg_config}"
    system "make", "PG_CONFIG=#{pg_config}", "install"
  end
end
