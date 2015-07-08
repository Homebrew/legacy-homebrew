class Btparse < Formula
  desc "BibTeX utility libraries"
  homepage "http://www.gerg.ca/software/btOOL/"
  url "http://www.gerg.ca/software/btOOL/btparse-0.34.tar.gz"
  sha256 "e8e2b6ae5de85d1c6f0dc52e8210aec51faebeee6a6ddc9bd975b110cec62698"

  bottle do
    cellar :any
    sha256 "a8488a0a2601b386d3f53d736d776d7a119d2910841959354cff91b9dec9d59f" => :yosemite
    sha256 "987a65ea6cbd04b6cb70d3f9f64791a1a69d5c69d446c6c712f463957435d0fb" => :mavericks
    sha256 "5ace9431c847dbe4a4d3f04045069eb51a036e9b5a2dce65ccdba7baf165540f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{mxcl09,
        title={{H}omebrew},
        author={{H}owell, {M}ax},
        journal={GitHub},
        volume={1},
        page={42},
        year={2009}
      }
    EOS

    system "#{bin}/bibparse", "-check", "test.bib"
  end
end
