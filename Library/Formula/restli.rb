require "formula"

class Restli < Formula
  homepage "http://rest.li/"
  url "http://rest.li/releases/restli-tool/0.0.1/restli-0.0.1.tar.gz"
  sha1 "38078f768fe463f39db2f69f896fa428ea7b4123"

  depends_on "giter8"

  def install
    bin.install 'restli'
  end

  test do
    (testpath/'input.txt').write('\norg.example\nfortunes\nfortunes\nFortune')
    system "#{bin}/restli", 'new', '--name=Example'
  end
end
