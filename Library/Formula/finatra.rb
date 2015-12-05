class Finatra < Formula
  desc "Scala web framework inspired by Sinatra"
  homepage "http://finatra.info/"
  url "https://github.com/twitter/finatra/archive/1.5.3.tar.gz"
  sha256 "aa4fab5ccdc012da9edf4650addf54b6ba64eb7e6a5e88d8c76e68e4d89216de"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"finatra"
  end

  test do
    system bin/"finatra"
  end
end
