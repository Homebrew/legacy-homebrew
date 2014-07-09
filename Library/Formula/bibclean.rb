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
      s.gsub! /[$][(]CP.*BIBCLEAN.*bindir.*BIBCLEAN[)]/, "mkdir -p $(bindir) && $(CP) $(BIBCLEAN) $(bindir)/$(BIBCLEAN)"
      s.gsub! /[$][(]CP.*bibclean.*mandir.*bibclean.*manext[)]/, "mkdir -p $(mandir) && $(CP) bibclean.man $(mandir)/bibclean.$(manext)"
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = $(prefix)/share/man/man1"
    end

    system "make", "all", "check", "install"
  end

  test do
    system "bibclean"
  end

end
