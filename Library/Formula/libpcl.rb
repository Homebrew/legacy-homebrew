require 'formula'

class Libpcl < Formula
  homepage 'http://xmailserver.org/libpcl.html'
  url 'http://xmailserver.org/pcl-1.12.tar.gz'
  sha1 'a206c8fb5a96e65005f414ac46aeccd4b3603c8d'

  bottle do
    cellar :any
    sha1 "5f5fa67315aa53eec8456101bf79d14d1b80f9ff" => :mavericks
    sha1 "3e68ab4a81fec5b4bc482cebe07a1d682d3e2b69" => :mountain_lion
    sha1 "06c814a3a004cd671996f4fbc15a395bd8046795" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
