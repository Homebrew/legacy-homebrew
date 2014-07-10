require "formula"

class Bibclean < Formula
  homepage "http://www.math.utah.edu/~beebe/software/bibtex-bibliography-tools.html"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-2.16.tar.gz"
  sha1 "f6790cd97e7fe05abce06c991d58e96b4b53ad04"

  # Our wrapper script.
  def bibclean_wrapper; <<-EOS.undent
    #!/bin/sh

    export PATH=$PATH:#{share}/bibclean
    "#{share}/bibclean/bibclean" "$@"
    EOS
  end

  # Test script. It basically checks that at least three initialization files
  # are loaded on execution, as should be the case.
  def bibclean_test; <<-EOS.undent
    test  `bibclean -author -trace-file-opening 2>&1 | grep "open file" | sed '/^\s*$/d' | wc -l` -ge 3
    EOS
  end

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

      # Place all initialization files in $(prefix)/bibclean/share/ instead of ./bin/ to comply with standard Unix practice.
      s.gsub! /install-ini.*uninstall-ini/, "install-ini:  uninstall-ini\n\tmkdir -p #{share}/bibclean"
      s.gsub! /[$][(]bindir[)].*bibcleanrc/, "#{share}/bibclean/.bibcleanrc"
      s.gsub! /[$][(]bindir[)].*bibclean.key/, "#{share}/bibclean/.bibclean.key"
      s.gsub! /[$][(]bindir[)].*bibclean.isbn/, "#{share}/bibclean/.bibclean.isbn"
    end

    # Build the binary.
    system "make", "all", "check", "install"

    # Tuck `bin/bibclean` away and create a `bibclean` wrapper script in its place.
    # The required $PATH adjustments are effected within the script,
    # so that successful installation does not rely on the user heeding the caveat.
    mv "#{bin}/bibclean", "#{share}/bibclean/"
    f = File.new("#{bin}/bibclean", "w")
    f.write(bibclean_wrapper)
    f.chmod(775)
    f.close
  end

  test do
    result = system "#{bibclean_test}"
    puts "Test passed"
  end

  def caveats; <<-EOS.undent
    bibclean requires access to several initialization files, with defaults
    available at #{HOMEBREW_PREFIX}/bibclean/share. The Homebrew build of bibclean
    is set up to automatically discover any initialization files across
    $PATH:#{HOMEBREW_PREFIX}/bibclean/share, therefore these defaults are active
    out of the box without any manual adjustments to $PATH on your part.

    For details and initialization options please consult the bibclean man page:

        $ man bibclean
    EOS
  end

end
