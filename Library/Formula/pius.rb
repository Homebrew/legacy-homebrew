class GnupgInstalled < Requirement
  fatal true

  satisfy { which('gpg') || which('gpg2') }

  def message; <<-EOS.undent
    Gnupg is required to use these tools.

    You can install Gnupg or Gnupg2.0.x or 2.1.x with Homebrew:
      brew install gnupg
      brew install gnupg2
      brew install gnupg21

    Or you can use one of several different
    prepackaged installers that are available.
    EOS
  end
end

class Pius < Formula
  homepage "http://www.phildev.net/pius/"
  url "https://downloads.sourceforge.net/project/pgpius/pius/2.0.11/pius-2.0.11.tar.bz2"
  sha1 "0c9b74f271bf195d8636d8406fbb56cc024195ad"

  depends_on GnupgInstalled

  def install
    # Replace hardcoded gpg path: https://sourceforge.net/p/pgpius/bugs/12/
    # Upstream have said WONTFIX. See new caveats for instructions.
    inreplace "pius", "/usr/bin/gpg", HOMEBREW_PREFIX/"bin/gpg"
    bin.install "pius"
    bin.install "pius-keyring-mgr"
    bin.install "pius-party-worksheet"
  end

  def caveats; <<-EOS.undent
    You will need to set:
      gpg-path=#{HOMEBREW_PREFIX/"bin/gpg"} or similar
    in your ~/.pius file to find the correct GPG to use.
    EOS
  end
end
