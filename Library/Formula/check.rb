class Check < Formula
  desc "C unit testing framework"
  homepage "http://check.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/check/check/0.10.0/check-0.10.0.tar.gz"
  sha256 "f5f50766aa6f8fe5a2df752666ca01a950add45079aa06416b83765b1cf71052"

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
