class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://code.google.com/p/git-multipush/"
  url "https://git-multipush.googlecode.com/files/git-multipush-2.3.tar.bz2"
  sha256 "1f3b51e84310673045c3240048b44dd415a8a70568f365b6b48e7970afdafb67"

  devel do
    url "https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.4.rc2.tar.gz"
    sha256 "999d9304f322c1b97d150c96be64ecde30980f97eaaa9d66f365b8b11894c46d"
    version "2.4-rc2"
  end

  head "https://github.com/gavinbeatty/git-multipush.git"

  depends_on "asciidoc" => :build

  def install
    system "make" if build.head?
    system "make", "prefix=#{prefix}", "install"
  end
end
