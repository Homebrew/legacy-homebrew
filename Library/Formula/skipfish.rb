require 'formula'

class Skipfish < Formula
  homepage 'http://code.google.com/p/skipfish/'
  url 'http://skipfish.googlecode.com/files/skipfish-2.07b.tgz'
  sha1 'eb8811137dd474adc02a657d371c4427b28f8d97'

  depends_on 'libidn'

  def install
    ENV.append "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    inreplace "config.h",
      "#define ASSETS_DIR              \"assets\"",
      "#define ASSETS_DIR	       \"#{libexec}/assets\""
    system 'make'
    bin.install 'skipfish'
    libexec.install %w(assets dictionaries)
  end

  def caveats; <<-EOS.undent
    NOTE: Skipfish uses dictionary-based probes and will not run until
    you have specified a dictionary for it to use.

    Please read #{libexec}/dictionaries/README-FIRST
    carefully to make the right choice. This step has a profound impact
    on the quality of results later on.

    Use this command to print usage information:
      skipfish -h

    EOS
  end
end
