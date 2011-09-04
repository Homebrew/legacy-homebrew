require 'formula'

class SigningParty < Formula
  url 'http://ftp.debian.org/debian/pool/main/s/signing-party/signing-party_1.1.3.orig.tar.gz'
  homepage 'http://pgp-tools.alioth.debian.org/'
  md5 '7d0207ce9415c1687b610be14da0b048'

  depends_on 'dialog'
  depends_on 'gnupg'
  depends_on 'qprint'
  depends_on 'GnuPG::Interface' => :perl
  depends_on 'Mime::Tools' => :perl
  depends_on 'Text::Iconv' => :perl
  depends_on 'Text::Template' => :perl

  def install
    system "make"

    # make install does not install all tools, so we'll do it manually. Will
    # tend to break on major changes, but tools in signing-party are quiet
    # stable.

    # caff
    bin.install ['caff/caff', 'caff/pgp-clean', 'caff/pgp-fixkey']
    # correct path in manpage
    inreplace 'caff/caff.1',
              '/usr/share/doc/signing\-party/caff/caffrc.sample',
              '#{share}/doc/caffrc.sample'
    man1.install ['caff/caff.1', 'caff/pgp-clean.1', 'caff/pgp-fixkey.1']
    (share + 'doc').install 'caff/caffrc.sample'

    # gpg-key2ps
    bin.install 'gpg-key2ps/gpg-key2ps'

    # gpg-mailkeys
    # no getent on OS X, some applescript magic
    inreplace 'gpg-mailkeys/gpg-mailkeys',
              'NAME=`getent passwd $USER | cut -d: -f5 | cut -d, -f1`',
              'NAME=`osascript -e "long user name of (system info)" 2>/dev/null`'
    bin.install 'gpg-mailkeys/gpg-mailkeys'
    man1.install 'gpg-mailkeys/gpg-mailkeys.1'
    (share + 'doc').install 'gpg-mailkeys/example.gpg-mailkeysrc'

    # gpgdir - Not included because it has it's own homepage. Should be a
    #          seperate formula. (http://www.cipherdyne.org/gpgdir/)

    # gpglist
    bin.install 'gpglist/gpglist'
    man1.install 'gpglist/gpglist.1'

    # gpgparticipants
    bin.install 'gpgparticipants/gpgparticipants'
    man1.install 'gpgparticipants/gpgparticipants.1'

    # gpgsigs
    bin.install 'gpgsigs/gpgsigs'
    man1.install 'gpgsigs/gpgsigs.1'

    # gpgwrap - Not included because it has it's own homepage. Should be a
    #           seperate formula. (http://unusedino.de/gpgwrap)

    # keyanalyze
    bin.install ['keyanalyze/keyanalyze',
                 'keyanalyze/process_keys',
                 'keyanalyze/pgpring/pgpring']
    man1.install ['keyanalyze/keyanalyze.1',
                  'keyanalyze/process_keys.1',
                  'keyanalyze/pgpring/pgpring.1']

    # keylookup
    bin.install 'keylookup/keylookup'
    man1.install 'keylookup/keylookup.1'

    # sig2dot
    bin.install 'sig2dot/sig2dot'
    man1.install 'sig2dot/sig2dot.1'

    # springgraph - Requires 'GD' => :perl which needs gdlib-config which is
    #               currently not available in homebrew.
    # bin.install 'springgraph/springgraph'
    # man1.install 'springgraph/springgraph.1'

  end
end
