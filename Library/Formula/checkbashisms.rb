require 'formula'

class Checkbashisms < Formula
  homepage 'http://manpages.ubuntu.com/manpages/natty/man1/checkbashisms.1.html'
  # Get upgrades at https://launchpad.net/ubuntu/+source/devscripts/
  url 'https://launchpad.net/ubuntu/+archive/primary/+files/devscripts_2.13.4.tar.xz'
  version '2.13.4'
  sha1 '94e7225c2f9f9062cea35c8010e984ae98834c28'

  depends_on 'xz' => :build

  def install
    inreplace 'scripts/checkbashisms.pl', '###VERSION###', "#{version}ubuntu1"
    bin.install 'scripts/checkbashisms.pl' => 'checkbashisms'
  end

  test do
    system "#{bin}/checkbashisms --version | grep #{version}"
  end
end
