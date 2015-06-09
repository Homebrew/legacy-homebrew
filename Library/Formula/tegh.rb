class Tegh < Formula
  desc "Command-line client for Prontserve"
  homepage "https://github.com/D1plo1d/tegh"
  url "https://s3.amazonaws.com/tegh_binaries/0.3.1/tegh-0.3.1-brew.tar.gz"
  sha256 "1aa9bdcc9579e8d56ab6a7b50704a1f32a6e5b8950ee2042f463b0a3b31daf4e"

  head "https://github.com/D1plo1d/tegh.git", :branch => "develop"

  depends_on "node"

  def install
    if build.head?
      ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
      ENV["HOME"] = buildpath/".brew_home"
      system "npm", "install"
    end

    rm "bin/tegh.bat"
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
