class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "http://hte.sf.net/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"

  bottle do
    cellar :any
    sha256 "5ec664d44de232a82b94ba1a2285f4c4a3b935b60f96ec83b75150e583323331" => :el_capitan
    sha256 "7705bf13e35efb021252aaf509e82a88f8996ad65199440eb46f2271bf77a570" => :yosemite
    sha256 "f41ba188255f61cd07be25969bce0a9667e81dfde9079ba17e7e329898cafed5" => :mavericks
    sha256 "dac5a797ccbeb46b89c7677997a3640b5ba5ce274c5f928bde9be91dbcbdd88a" => :mountain_lion
  end

  depends_on "lzo"

  def install
    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
