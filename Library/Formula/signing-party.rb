require "formula"

class GnupgInstalled < Requirement
  fatal true
  default_formula "gnupg"
  satisfy { which("gpg") || which("gpg2") }
end

class SigningParty < Formula
  homepage "http://pgp-tools.alioth.debian.org/"
  url "http://ftp.debian.org/debian/pool/main/s/signing-party/signing-party_1.1.7.orig.tar.gz"
  sha1 "8bb854eab064b67740a23c44c1bb2eb497d9fdeb"

  option 'with-rename-pgpring', 'Install pgpring as pgppubring to avoid conflicting with mutt'

  if build.without? 'rename-pgpring'
    conflicts_with 'mutt',
      :because => 'mutt installs a private copy of pgpring'
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dialog"
  depends_on "qprint"
  depends_on GnupgInstalled

  resource "GnuPG::Interface" do
    url "http://search.cpan.org/CPAN/authors/id/A/AL/ALEXMV/GnuPG-Interface-0.50.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/A/AL/ALEXMV/GnuPG-Interface-0.50.tar.gz"
    sha1 "471c61d262552548df5980cbfc5ccbe6a4607aca"
  end

  resource "Text::Iconv" do
    url "http://search.cpan.org/CPAN/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz"
    sha1 "542849325b2d66c72e19ffb48bdc67fdd7e4bbea"
  end

  resource "Text::Template" do
    url "http://search.cpan.org/CPAN/authors/id/M/MJ/MJD/Text-Template-1.46.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/M/MJ/MJD/Text-Template-1.46.tar.gz"
    sha1 "008df9cfa6f9ab8d0b4f38c3e59d4e8679280bc1"
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

    doc.install 'README'

    cd 'caff' do
      inreplace 'caff', '/usr/share/doc/signing-party', HOMEBREW_PREFIX/'share/doc/signing-party'
      system "make"
      man1.install Dir['*.1']
      bin.install 'caff', 'pgp-clean', 'pgp-fixkey'
      (doc/'caff').install Dir['README*', 'caffrc.sample']
    end

    cd 'gpg-key2ps' do
      system "make"
      man1.install 'gpg-key2ps.1'
      bin.install 'gpg-key2ps'
      (doc/'key2ps').install 'README'
    end

    cd 'gpg-mailkeys' do
      inreplace 'gpg-mailkeys',
        %q[`getent passwd $USER | cut -d: -f5 | cut -d, -f1`],
        %q[`osascript -e "long user name of (system info)" 2>/dev/null`]

      bin.install 'gpg-mailkeys'
      man1.install 'gpg-mailkeys.1'
      (doc/'gpg-mailkeys').install 'README', 'example.gpg-mailkeysrc'
    end

    cd 'gpglist' do
      system "make"
      bin.install 'gpglist'
      man1.install 'gpglist.1'
    end

    cd 'gpgparticipants' do
      bin.install 'gpgparticipants'
      man1.install 'gpgparticipants.1'
    end

    cd 'gpgsigs' do
      system "make"
      man1.install 'gpgsigs.1'
      bin.install 'gpgsigs'
      (doc/'gpgsigs').install Dir['gpgsigs-lt2k5*.txt']
    end

    cd 'keyanalyze' do
      inreplace "pgpring/configure.in", "AM_C_PROTOTYPES", ""
      inreplace "Makefile", "automake-1.11 --add-missing && automake-1.11", "autoreconf -fvi"
      system "make"
      if build.with? 'rename-pgpring'
        # Install pgpring as pgppubring to avoid conflicting with Mutt.
        # Reflect the installed name in manpages.
        inreplace %w(keyanalyze.1 pgpring/pgpring.1 process_keys.1), /pgpring/, "pgppubring"
        bin.install 'pgpring/pgpring' => 'pgppubring'
        man1.install 'pgpring/pgpring.1' => 'pgppubring.1'
      else
        bin.install 'pgpring/pgpring'
        man1.install 'pgpring/pgpring.1'
      end
      bin.install 'keyanalyze', 'process_keys'
      man1.install 'keyanalyze.1', 'process_keys.1'
    end

    cd 'keylookup' do
      bin.install 'keylookup'
      man1.install 'keylookup.1'
    end

    cd 'sig2dot' do
      bin.install 'sig2dot'
      man1.install 'sig2dot.1'
      (doc/'sig2dot').install 'README.sig2dot'
    end

    bin.env_script_all_files(libexec+"bin", "PERL5LIB" => ENV["PERL5LIB"])
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
