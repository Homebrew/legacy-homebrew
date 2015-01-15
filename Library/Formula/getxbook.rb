class Getxbook < Formula
  homepage "http://njw.me.uk/software/getxbook/"
  url "http://njw.me.uk/software/getxbook/getxbook-1.1.tar.bz2"
  sha1 "9d47918ed77e8fb4f4e8b3c412cdcc82834be3e8"

  option "with-gui", "Build the GUI"

  depends_on "tcl-tk" if build.with? "gui"

  def install
    args = %W[CC=#{ENV.cc} PREFIX=#{prefix}]
    args << "install" if build.with?("gui")

    system "make", *args
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
