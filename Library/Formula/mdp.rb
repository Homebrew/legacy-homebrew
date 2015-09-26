class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.0.tar.gz"
  sha256 "76a3a6eafb2879bb7a8deef223a7244401506d8e3c2f91b6eb81d6a238fb75f6"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any
    sha256 "954220348b4a6ce5aa97edfa1eab40aff944bd804226f1d01117bd22ba220b07" => :yosemite
    sha256 "b4dac048d07a19e5b4955578030e9e68638f28b8d7c26d98492cf1eea152b1f0" => :mavericks
    sha256 "84f070d0885fef35a596ae523609f38c9d72697a9b7facdbe1d8d2657f509f4e" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    share.install "sample.md"
  end

  test do
    # Go through two slides and quit.
    ENV["TERM"] = "xterm"
    pipe_output "#{bin}/mdp #{share}/sample.md", "jjq", 0
  end
end
