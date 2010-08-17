require 'formula'

class Skipfish <Formula
  url 'http://skipfish.googlecode.com/files/skipfish-1.55b.tgz'
  homepage 'http://code.google.com/p/skipfish/'
  md5 '6dfa72d6e04e90600a7a63d7d88d72a9'
  depends_on 'libidn'

  def install
    ENV.append "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    inreplace "config.h",
      "#define ASSETS_DIR              \"assets\"",
      "#define ASSETS_DIR	       \"#{libexec}/assets\""
    system "make"
    bin.install "skipfish"
    libexec.install ["dictionaries", "assets"]
  end

  def caveats; <<-EOS.undent
    NOTE: Skipfish uses dictionary-based probes and will not run until
    you have specified a dictionary for it to use.

    Please read #{libexec}/dictionaries/README-FIRST
    carefully to make the right choice. This step has a profound impact
    on the quality of results later on.

    "skipfish -h" prints out usage information.
    EOS
  end
end
