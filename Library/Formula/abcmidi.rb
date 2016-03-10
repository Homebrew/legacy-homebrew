class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2016.03.03.zip"
  version "2016-03-03"
  sha256 "a9070dbb49758474805252d1a3e837aef8dc1266f6415f8eccc7df118af3dc1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa5e2f014d6b0cfccc6170c01db070dde3e55b8c620792d64f94da49d59d32d4" => :el_capitan
    sha256 "e427b95a6b3a7d1ee12b5cd2d30bdd87f41bc77a8834fc9f15bfe4d77f22e1db" => :yosemite
    sha256 "211c580f9941f3e3c6189c57ebb902e33bcfc54d24292de4e08f7a146d2c85e1" => :mavericks
    sha256 "09c43c49c3a7dae429429acc2a31b0942ba540636fa598a648576e007cde988f" => :mountain_lion
  end

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    rm "makefile"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<-EOF.undent
      X: 1
      T: Abdala
      F: http://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOF

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
