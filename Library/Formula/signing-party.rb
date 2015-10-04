class SigningParty < Formula
  desc "Various OpenPGP related tools"
  homepage "https://pgp-tools.alioth.debian.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/signing-party/signing-party_2.1.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/signing-party/signing-party_2.1.orig.tar.gz"
  sha256 "ca87849a74ea4c271e92422bfe6b1be2bfe2c2de9a723bf11aa088e4ea88965d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0692c36cb488a6513418aa680b047f66330a48b6273c80d7f7d64c4a56a5bf48" => :el_capitan
    sha256 "33115eca8d24439f772797d16e727b158befc4f71f119cdde01cd795c73b7e17" => :yosemite
    sha256 "fb5a0eb7e0ddda57f16b2d12d7f11325cea737cb180c8a29f44cd88af13d29ab" => :mavericks
  end

  option "with-rename-pgpring", "Install pgpring as pgppubring to avoid conflicting with mutt"

  if build.without? "rename-pgpring"
    conflicts_with "mutt",
      :because => "mutt installs a private copy of pgpring"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dialog"
  depends_on "qprint"
  depends_on :gpg

  resource "GnuPG::Interface" do
    url "https://cpan.metacpan.org/authors/id/A/AL/ALEXMV/GnuPG-Interface-0.52.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/A/AL/ALEXMV/GnuPG-Interface-0.52.tar.gz"
    sha256 "247a9f5a88bb6745281c00d0f7d5d94e8599a92396849fd9571356dda047fd35"
  end

  resource "Text::Iconv" do
    url "https://cpan.metacpan.org/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz"
    sha256 "5b80b7d5e709d34393bcba88971864a17b44a5bf0f9e4bcee383d029e7d2d5c3"
  end

  resource "Text::Template" do
    url "https://cpan.metacpan.org/authors/id/M/MJ/MJD/Text-Template-1.46.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MJ/MJD/Text-Template-1.46.tar.gz"
    sha256 "77d812cb86e48091bcd59aa8522ef887b33a0ff758f8a269da8c2b733889d580"
  end

  resource "Net::IDN::Encode" do
    url "https://cpan.metacpan.org/authors/id/C/CF/CFAERBER/Net-IDN-Encode-2.300.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CF/CFAERBER/Net-IDN-Encode-2.300.tar.gz"
    sha256 "46b18a0a933af6709079eb5090cab2f4b382b07000672708bce0aec9135e56fc"
  end

  resource "Type::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-1.000005.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TOBYINK/Type-Tiny-1.000005.tar.gz"
    sha256 "42ed36c011825aa1e6995a4e8638621a1b2103a0970b15764ca3919368042365"
  end

  resource "Exporter::Tiny" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Exporter-Tiny-0.042.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TOBYINK/Exporter-Tiny-0.042.tar.gz"
    sha256 "8f1622c5ebbfbcd519ead81df7917e48cb16cc527b1c46737b0459c3908a023f"
  end

  # prerequisite MooX::late 0.014
  resource "MooX::late" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/MooX-late-0.014.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/T/TO/TOBYINK/MooX-late-0.014.tar.gz"
    sha256 "7bc00d77a720319b1baf7fbde99d42beac87de256cee44d2f32be25014a5e707"
  end

  # prerequisite MooX::HandlesVia 0.001004
  resource "MooX::HandlesVia" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTP/MooX-HandlesVia-0.001004.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MATTP/MooX-HandlesVia-0.001004.tar.gz"
    sha256 "f25e7ce1a8247f2cae7ab84e5467ff6d7d932ca2e9cc1efa4e4b57e2101a8b16"
  end

  resource "Data::Perl" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTP/Data-Perl-0.002009.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MATTP/Data-Perl-0.002009.tar.gz"
    sha256 "b62b2225870c2c3b16fb78c429f8729ddb8ed0e342f4209ec3c261b764c36f8b"
  end

  resource "CPAN::Meta::Requirements" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.133.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.133.tar.gz"
    sha256 "8cd3e2ce06032f6e5ae79b329735c9aa6f01cadba07c5cfe692e35e43b38eb04"
  end

  # gpgparticipants data on OS X behaves differently from linux version
  # https://github.com/Homebrew/homebrew/pull/21628
  patch :DATA

  def install
    # gpgdir and gpgwrap are not included as they have their own homepages
    # springraph is not included because it depends on the 'GD' perl module
    # which has its own dependency issues

    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    doc.install "README"

    cd "caff" do
      inreplace "caff", "/usr/share/doc/signing-party", HOMEBREW_PREFIX/"share/doc/signing-party"
      system "make"
      man1.install Dir["*.1"]
      bin.install "caff", "pgp-clean", "pgp-fixkey"
      (doc/"caff").install Dir["README*", "caffrc.sample"]
    end

    cd "gpg-key2ps" do
      system "make"
      man1.install "gpg-key2ps.1"
      bin.install "gpg-key2ps"
      (doc/"key2ps").install "README"
    end

    cd "gpg-mailkeys" do
      inreplace "gpg-mailkeys",
        "`getent passwd $USER | cut -d: -f5 | cut -d, -f1`",
        '`osascript -e "long user name of (system info)" 2>/dev/null`'

      bin.install "gpg-mailkeys"
      man1.install "gpg-mailkeys.1"
      (doc/"gpg-mailkeys").install "README", "example.gpg-mailkeysrc"
    end

    cd "gpglist" do
      system "make"
      bin.install "gpglist"
      man1.install "gpglist.1"
    end

    cd "gpgparticipants" do
      bin.install "gpgparticipants"
      man1.install "gpgparticipants.1"
    end

    cd "gpgsigs" do
      system "make"
      man1.install "gpgsigs.1"
      bin.install "gpgsigs"
      (doc/"gpgsigs").install Dir["gpgsigs-lt2k5*.txt"]
    end

    cd "keyanalyze" do
      inreplace "pgpring/configure.in", "AM_C_PROTOTYPES", ""
      inreplace "Makefile", "automake-1.11 --add-missing && automake-1.11", "autoreconf -fvi"
      system "make"
      if build.with? "rename-pgpring"
        # Install pgpring as pgppubring to avoid conflicting with Mutt.
        # Reflect the installed name in manpages.
        inreplace %w[keyanalyze.1 pgpring/pgpring.1 process_keys.1], /pgpring/, "pgppubring"
        bin.install "pgpring/pgpring" => "pgppubring"
        man1.install "pgpring/pgpring.1" => "pgppubring.1"
      else
        bin.install "pgpring/pgpring"
        man1.install "pgpring/pgpring.1"
      end
      bin.install "keyanalyze", "process_keys"
      man1.install "keyanalyze.1", "process_keys.1"
    end

    cd "keylookup" do
      bin.install "keylookup"
      man1.install "keylookup.1"
    end

    cd "sig2dot" do
      bin.install "sig2dot"
      man1.install "sig2dot.1"
      (doc/"sig2dot").install "README.sig2dot"
    end

    bin.env_script_all_files(libexec+"bin", "PERL5LIB" => ENV["PERL5LIB"])
  end

  test do
    args = "--frontend=plain --keyserver=hkps.pool.sks-keyservers.net 0xE33A3D3CCE59E297"
    assert_match /security@brew.sh/, shell_output("#{bin}/keylookup #{args}")
  end
end

__END__
diff --git a/gpgparticipants/gpgparticipants b/gpgparticipants/gpgparticipants
index aaf97bb..7a6bd38 100755
--- a/gpgparticipants/gpgparticipants
+++ b/gpgparticipants/gpgparticipants
@@ -65,7 +65,7 @@ title=$(echo "$5"|tr a-z A-Z|sed 's/\(.\)/\1 /g')
 [ "$output" = - ] && output=/path/to/ksp-file.txt || { exec > "$output"; }

 # Date of event
-LC_ALL=C date --date="$date" +"%A, %B %e, %Y;  %H:%M"
+LC_ALL=C date -j -f "%Y%m%d %H%M" "$date" +"%A, %B %e, %Y;  %H:%M"
 # Organiser contact
 printf "%80s\n\n\n" "$org"
 # Title
