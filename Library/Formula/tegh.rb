class Tegh < Formula
  desc "Command-line client for Prontserve"
  homepage "https://github.com/D1plo1d/tegh"
  url "https://s3.amazonaws.com/tegh_binaries/0.3.1/tegh-0.3.1-brew.tar.gz"
  sha256 "1aa9bdcc9579e8d56ab6a7b50704a1f32a6e5b8950ee2042f463b0a3b31daf4e"

  head "https://github.com/D1plo1d/tegh.git", :branch => "develop"

  bottle do
    sha256 "e331da57cd2bb89b5ac54ac12535c388495985c22046a565ec7799ba0b238eca" => :yosemite
    sha256 "c2f4b64b7945944f0e99bd208dc9320b169116152208623a0189c7b09ed7bb7b" => :mavericks
    sha256 "15207ec101af6d37b427abb9f6e5e4032373cd9b8f4fda260f0dbc4ae7987459" => :mountain_lion
  end

  depends_on "node"

  def install
    if build.head?
      ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
      system "npm", "install"
    end

    rm "bin/tegh.bat"
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
