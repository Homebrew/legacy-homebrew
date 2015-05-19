class Betty < Formula
  desc "English-like interface for the command-line"
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/v0.1.7.tar.gz"
  sha1 "ec21ec5541289a9902874c7897f8d521044daf27"

  depends_on :ruby => "1.9"

  def install
    libexec.install "lib", "main.rb" => "betty"
    bin.write_exec_script libexec/"betty"
  end

  test do
    system bin/"betty", "what is your name"
    system bin/"betty", "version"
  end
end
