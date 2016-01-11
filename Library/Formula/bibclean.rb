class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "http://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-2.16.tar.gz"
  sha256 "b8e7f89219e04a2b130d9d506b79265e9981b065ad32652a912211a6057428df"

  bottle do
    cellar :any
    sha256 "825009ac0bf781d29eedf23461d0032c1e57658fb53a4568931bd8e11bbec4bb" => :mavericks
    sha256 "8bf50caf3f23d51de83e0805597bb1ca4f6aeb9e8a28bd03514f5345bdff7cc1" => :mountain_lion
    sha256 "fb6023f2320a019d6bc0a46376f636e2b330776a22510469fc00715f10203044" => :lion
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in OS X
      # requires that the full path to the target already exist.
      s.gsub! /[$][(]CP.*BIBCLEAN.*bindir.*BIBCLEAN[)]/,
              "mkdir -p $(bindir) && $(CP) $(BIBCLEAN) $(bindir)/$(BIBCLEAN)"
      s.gsub! /[$][(]CP.*bibclean.*mandir.*bibclean.*manext[)]/,
              "mkdir -p $(mandir) && $(CP) bibclean.man $(mandir)/bibclean.$(manext)"

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = $(prefix)/share/man/man1"

      # Place all initialization files in $(prefix)/bibclean/share/ instead of
      # ./bin/ to comply with standard Unix practice.
      s.gsub! /install-ini.*uninstall-ini/,
              "install-ini:  uninstall-ini\n\tmkdir -p #{share}/bibclean"
      s.gsub! /[$][(]bindir[)].*bibcleanrc/,
              "#{share}/bibclean/.bibcleanrc"
      s.gsub! /[$][(]bindir[)].*bibclean.key/,
              "#{share}/bibclean/.bibclean.key"
      s.gsub! /[$][(]bindir[)].*bibclean.isbn/,
              "#{share}/bibclean/.bibclean.isbn"
    end

    system "make", "all"
    system "make", "check"
    system "make", "install"

    ENV.prepend_path "PATH", share+"bibclean"
    bin.env_script_all_files(share+"bibclean", :PATH => ENV["PATH"])
  end

  test do
    (testpath+"test.bib").write <<-EOS.undent
      @article{small,
      author = {Test, T.},
      title = {Test},
      journal = {Test},
      year = 2014,
      note = {test},
      }
    EOS

    system "#{bin}/bibclean", "test.bib"
  end
end
