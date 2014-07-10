require "formula"

class Bibclean < Formula
  homepage "http://www.math.utah.edu/~beebe/software/bibtex-bibliography-tools.html"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-2.16.tar.gz"
  sha1 "f6790cd97e7fe05abce06c991d58e96b4b53ad04"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in OS X
      # requires that the full path to the target already exist.
      s.gsub! /[$][(]CP.*BIBCLEAN.*bindir.*BIBCLEAN[)]/, "mkdir -p $(bindir) && $(CP) $(BIBCLEAN) $(bindir)/$(BIBCLEAN)"
      s.gsub! /[$][(]CP.*bibclean.*mandir.*bibclean.*manext[)]/, "mkdir -p $(mandir) && $(CP) bibclean.man $(mandir)/bibclean.$(manext)"
      # Correct `mandir` (man file path) in the Makefile.
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = $(prefix)/share/man/man1"
      s.gsub! /install-ini.*uninstall-ini/, "install-ini:  uninstall-ini\n\tmkdir -p $(prefix)/share"
      # Place all initialization files in $(prefix)/share/, not ./bin/ to comply with standard Unix practice.
      s.gsub! /[$][(]bindir[)].*bibcleanrc/, "$(prefix)/share/.bibcleanrc"
      s.gsub! /[$][(]bindir[)].*bibclean.key/, "$(prefix)/share/.bibclean.key"
      s.gsub! /[$][(]bindir[)].*bibclean.isbn/, "$(prefix)/share/.bibclean.isbn"
    end
    system "make", "all", "check", "install"
  end

  test do
    system "bibclean"
  end

  def caveats; <<-EOS.undent
    bibclean requires access to several initialization files, with defaults
    available at #{HOMEBREW_PREFIX}/share. It is strongly recommended to append
    this path to your $PATH prior to running bibclean:

        $ export PATH=$PATH:#{HOMEBREW_PREFIX}/share

    For more initialization options, please consult the bibclean man page:

        $ man bibclean
    EOS
  end

end
