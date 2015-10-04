class Diffuse < Formula
  desc "Graphical tool for merging and comparing text files"
  homepage "http://diffuse.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/diffuse/diffuse/0.4.8/diffuse-0.4.8.tar.bz2"
  sha256 "c1d3b79bba9352fcb9aa4003537d3fece248fb824781c5e21f3fcccafd42df2b"

  depends_on "pygtk"

  def install
    system "python", "./install.py",
                     "--sysconfdir=#{etc}",
                     "--examplesdir=#{share}",
                     "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/diffuse", "--help"
  end
end
