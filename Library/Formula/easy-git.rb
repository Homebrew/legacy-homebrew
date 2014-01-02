require 'formula'

class EasyGit < Formula
  homepage 'http://people.gnome.org/~newren/eg/'
  url 'http://people.gnome.org/~newren/eg/download/1.7.5.2/eg', :using => :ssl3
  version '1.7.5.2'
  sha1 'c59a10affaae79bddbbe1de743d85d7771575905'

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
