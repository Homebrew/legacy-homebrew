class Daemonize < Formula
  desc "Run a command as a UNIX daemon"
  homepage "http://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.6.tar.gz"
  sha256 "8d5717ae5e5bbd4cd6687abe1310f4d817468c67b851ce95dda73038ab40db1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5858614b5ecf028c60e72a560beaeb8dc8fe098919336595ff86d68318addd4c" => :el_capitan
    sha256 "f030b352d61fa673e81d84ee041c6922f3615cb7761b68e090329a406248d322" => :yosemite
    sha256 "a8713e370c1c2677bff6bfd30722eefa79daca3352a6e79d6dc4315b782bea61" => :mavericks
    sha256 "94bb0d065fd5e3a7fe43ae3df279e7eac2c6c65455bf2821981a838789365435" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
