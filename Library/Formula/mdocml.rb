class Mdocml < Formula
  homepage "http://mdocml.bsd.lv/"
  url "http://mdocml.bsd.lv/snapshots/mdocml-1.13.2.tar.gz"
  sha1 "0d3c4e72214f73ee81c02e9b8863db0bc8f85aaf"

  keg_only :provided_by_osx, <<-EOS.undent
    In addition it may conflict with the groff formula from the homebrew-dupes tap.
  EOS
  
  def install
    ENV.deparallelize
    (buildpath+"configure.local").write <<-EOS.undent
      PREFIX="#{prefix}"
      MANDIR="#{man}"
    EOS
    system "./configure"
    system "make", "install"
  end

  test do
    assert_match /^MANDOC\(1\)\s+General Commands Manual\s+MANDOC\(1\)/, shell_output("#{bin}/mandoc #{man1}/mandoc.1")
  end
end
