require "formula"

class Ruby19Dependency < Requirement
  fatal true
  default_formula "ruby"

  satisfy do
    `ruby --version` =~ /ruby (\d\.\d).\d/
    $1.to_f >= 1.9
  end

  def message
    "Betty requires Ruby 1.9 or better."
  end
end

class Betty < Formula
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/v0.1.7.tar.gz"
  sha1 "ec21ec5541289a9902874c7897f8d521044daf27"

  depends_on Ruby19Dependency

  def install
    libexec.install "lib", "main.rb" => "betty"
    bin.write_exec_script libexec/"betty"
  end

  test do
    system bin/"betty", "speech on"
    system bin/"betty", "what is your name"
    system bin/"betty", "version"
    system bin/"betty", "speech off"
  end
end
