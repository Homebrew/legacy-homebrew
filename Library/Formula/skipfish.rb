require 'formula'

class Skipfish <Formula
  url 'http://skipfish.googlecode.com/files/skipfish-1.29b.tgz'
  homepage 'http://code.google.com/p/skipfish/'
  md5 '84544ad46472d1f5eb22987aaa06333e'

  depends_on 'libidn'

  def install
    ENV.append "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    inreplace "config.h",
      "#define ASSETS_DIR              \"assets\"",
      "#define ASSETS_DIR	       \"#{libexec}/assets\""
    system "make"
    bin.install "skipfish"
    (libexec+"dictionaries").install Dir["dictionaries/*"]
    (libexec+"assets").install Dir["assets/*"]
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
