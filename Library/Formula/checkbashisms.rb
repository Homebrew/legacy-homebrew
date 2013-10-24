require 'formula'

class Checkbashisms < Formula
  homepage 'http://manpages.ubuntu.com/manpages/natty/man1/checkbashisms.1.html'
  url 'https://launchpad.net/ubuntu/+archive/primary/+files/devscripts_2.13.0ubuntu1.tar.xz'
  version '2.13.0'
  sha1 'be8b7e2fb596ea8ba098111ced04a7cd0abfb4d1'

  depends_on 'xz' => :build

  def install
    inreplace 'scripts/checkbashisms.pl', '###VERSION###', "#{version}ubuntu1"
    bin.install 'scripts/checkbashisms.pl' => 'checkbashisms'
  end

  test do
    system "#{bin}/checkbashisms --version | grep #{version}"
  end
end
