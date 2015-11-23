class Wwwoffle < Formula
  desc "Better browsing for computers with intermittent connections"
  homepage "http://www.gedanken.org.uk/software/wwwoffle/"
  url "http://www.gedanken.org.uk/software/wwwoffle/download/wwwoffle-2.9i.tgz"
  sha256 "e6341a4ec2631dc22fd5209c7e5ffe628a5832ad191d444c56aebc3837eed2ae"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
