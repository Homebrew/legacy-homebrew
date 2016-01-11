class Skipfish < Formula
  desc "Web application security scanner"
  homepage "https://code.google.com/p/skipfish/"
  url "https://skipfish.googlecode.com/files/skipfish-2.10b.tgz"
  sha256 "1a4fbc9d013f1f9b970946ea7228d943266127b7f4100c994ad26c82c5352a9e"
  revision 1

  bottle do
    sha256 "b897550f5399004d0082a8a5acb0aa7c4f20c92a9033d486c6172da30bd260d3" => :el_capitan
    sha256 "a055fdc76fae7fc46cf6c2098ac21b7e88bfcc63c29c88e9727f0ecb83a4e99d" => :yosemite
    sha256 "ed0cf629f0dd2f23782ff21bb728efe019d8bd84605f9ca85a317ef9841b5d8b" => :mavericks
  end

  depends_on "libidn"
  depends_on "pcre"
  depends_on "openssl"

  def install
    ENV.append "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    chmod 0755, "src/config.h" # Not writeable in the tgz. Lame.
    inreplace "src/config.h",
      "#define ASSETS_DIR              \"assets\"",
      "#define ASSETS_DIR	       \"#{libexec}/assets\""

    system "make"
    bin.install "skipfish"
    libexec.install %w[assets dictionaries config signatures doc]
  end

  def caveats; <<-EOS.undent
    NOTE: Skipfish uses dictionary-based probes and will not run until
    you have specified a dictionary for it to use. Please read:
      #{libexec}/doc/dictionaries.txt
    carefully to make the right choice. This step has a profound impact
    on the quality of results later on.

    Use this command to print usage information:
      skipfish -h
    EOS
  end
end
