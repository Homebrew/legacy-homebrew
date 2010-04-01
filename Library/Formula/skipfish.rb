require 'formula'

class Skipfish <Formula
  url 'http://skipfish.googlecode.com/files/skipfish-1.25b.tgz'
  homepage 'http://code.google.com/p/skipfish/'
  md5 '6563633524e58592081b169fdbb28d47'

  depends_on 'libidn'

  def install
    ENV.append "CFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    inreplace "config.h",
      "#define ASSETS_DIR              \"assets\"",
      "#define ASSETS_DIR		 \"#{prefix}/share/skipfish/assets\""
    system "make"
    bin.install "skipfish"
    (share+"skipfish/dictionaries").install Dir["dictionaries/*"]
    (share+"skipfish/assets").install Dir["assets/*"]
  end

  def caveats; <<-EOS.undent

    NOTE: Skipfish uses dictionary-based probes and will not run until you
    have selected and made a copy of a dictionary for it to use.

    Please read consult dictionaries/README-FIRST carefully to make the right
    choice. This step has a profound impact on the quality of scan results
    later on.

    #{HOMEBREW_PREFIX}/lib/skipfish/dictionaries/README-FIRST

    EOS
  end
end
