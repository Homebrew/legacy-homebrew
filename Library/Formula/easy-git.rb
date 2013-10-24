require 'formula'

class EasyGit < Formula
  homepage 'http://people.gnome.org/~newren/eg/'
  url 'http://people.gnome.org/~newren/eg/download/1.7.3/eg', :using => :ssl3
  version "1.7.3"
  sha1 'd17165c20ea1b3887f1f81ec6d1217727b817409'

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
