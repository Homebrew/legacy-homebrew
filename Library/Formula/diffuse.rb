require 'formula'

class Diffuse < Formula
  homepage 'http://diffuse.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/diffuse/diffuse/0.4.6/diffuse-0.4.6.tar.bz2'
  sha1 '29439e2a069ec00bc50347a59ec410d79ab3735e'

  depends_on 'pygtk'

  def install
    system "python", "./install.py",
                     "--sysconfdir=#{etc}",
                     "--examplesdir=#{share}",
                     "--prefix=#{prefix}"
  end

  def test
    system "#{bin}/diffuse", "--help"
  end
end
