require "formula"

class Diffuse < Formula
  homepage "http://diffuse.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/diffuse/diffuse/0.4.8/diffuse-0.4.8.tar.bz2"
  sha1 "473f7e82f57cc3a5ce0378eea8aede19a3f2a9df"

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
