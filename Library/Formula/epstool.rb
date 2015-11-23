class Epstool < Formula
  desc "Edit preview images and fix bounding boxes in EPS files"
  homepage "http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm"
  url "http://pkgs.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/epstool-3.08.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/epstool-3.08.tar.gz"
  sha256 "f3f14b95146868ff3f93c8720d5539deef3b6531630a552165664c7ee3c2cfdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "92efa66cd268f0447dc52c14e9da04ae8af01b1691ec8eec3df61bbeb947b713" => :el_capitan
    sha1 "72c9a1b0dcc2fba03d6ca3f798b511c32129f346" => :yosemite
    sha1 "51ac90156f7dd505f717661814f72519657d6454" => :mavericks
    sha1 "2ea650f6125f4325ffb74ebe9396f91de9785980" => :mountain_lion
  end

  depends_on "ghostscript"

  def install
    system "make", "install",
                   "EPSTOOL_ROOT=#{prefix}",
                   "EPSTOOL_MANDIR=#{man}",
                   "CC=#{ENV.cc}"
  end

  test do
    system bin/"epstool", "--add-tiff-preview", "--device", "tiffg3", test_fixtures("test.eps"), "test2.eps"
    assert File.exist?("test2.eps")
  end
end
