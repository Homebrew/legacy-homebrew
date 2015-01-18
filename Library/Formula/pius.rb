class Pius < Formula
  homepage "http://www.phildev.net/pius/"
  url "https://downloads.sourceforge.net/project/pgpius/pius/2.0.11/pius-2.0.11.tar.bz2"
  sha1 "0c9b74f271bf195d8636d8406fbb56cc024195ad"

  depends_on :gpg

  def install
    # Replace hardcoded gpg path: https://sourceforge.net/p/pgpius/bugs/12/
    inreplace "pius", "/usr/bin/gpg", HOMEBREW_PREFIX/"bin/gpg"
    bin.install "pius"
    bin.install "pius-keyring-mgr"
    bin.install "pius-party-worksheet"
  end

  def caveats; <<-EOS.undent
      The gpg path is hardcoded in pius. You can specific your own gpg path
      by adding follow line into ~/.pius file:
        gpg-path=/path/to/gpg
    EOS
  end

  test do
    system "#{bin}/pius", "-T"
  end
end
