class Check < Formula
  desc "C unit testing framework"
  homepage "http://check.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/check/check/0.9.14/check-0.9.14.tar.gz"
  sha256 "c272624645b1b738cf57fd5d81a3e4d9b722b99d6133ee3f3c4007d4d279840a"

  bottle do
    cellar :any
    sha1 "5f7d4c82f1c2bdb365718e97299efd47ec9c7272" => :mavericks
    sha1 "2390f4c06a316a18cd4a9164fcd510c1ffb9a276" => :mountain_lion
    sha1 "99d8dfd79c4498071ac91dcc782b5b27f2182614" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
