class Btparse < Formula
  homepage "http://www.gerg.ca/software/btOOL/"
  url "http://www.gerg.ca/software/btOOL/btparse-0.34.tar.gz"
  sha256 "e8e2b6ae5de85d1c6f0dc52e8210aec51faebeee6a6ddc9bd975b110cec62698"

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
