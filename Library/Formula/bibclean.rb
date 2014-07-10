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
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # Tuck `bin/bibclean` away and create a `bibclean` wrapper script in its place.
    # The PATH is adjusted within the script so that the default initialization
    # files are found.
    bin.env_script_all_files(share + 'bibclean', :PATH => ENV['PATH'] + ":#{share}/bibclean")

  end

  # Test script. It checks that the binary runs and at least three initialization files
  # are loaded on execution, as should be the case.
  test do
    result = system %(test  `bibclean -author -trace-file-opening 2>&1 | grep "open file" | sed '/^\s*$/d' | wc -l` -ge 3)
    puts "Test passed"
  end

end
