require 'formula'

class EasyGit < Formula
  homepage 'http://people.gnome.org/~newren/eg/'
  url 'http://people.gnome.org/~newren/eg/download/1.7.5.2/eg', :using => :ssl3
  sha256 '59bb4f8b267261ab3d48c66b957af851d1a61126589173ebcc20ba9f43c382fb'
  version '1.7.5.2'

  def install
    bin.install "eg"
  end

  test do
    system "#{bin}/eg", "help"
  end
end
