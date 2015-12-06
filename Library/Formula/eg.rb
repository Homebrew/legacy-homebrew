class Eg < Formula
  homepage "https://github.com/srsudar/eg"
  desc "Useful examples for command-line tools."
  url "https://github.com/srsudar/eg/archive/v0.0.3.tar.gz"
  sha256 "c257e334f2a2e494f9b9791b92c1d3f7b00da3e2e7ec47f02d720342b466f968"

  def install
    share.install "eg/examples"
    inreplace "eg/eg_config.py",
              /DEFAULT_EXAMPLES_DIR = .+$/,
              "DEFAULT_EXAMPLES_DIR = os.path.join('#{share}', 'examples')"

    prefix.install "eg" => "commands"
    inreplace "bin/eg",
              "from eg import eg_exec",
              <<-EOS.undent
              import os.path
              import sys
              sys.path.append(os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'commands')))
              import eg_exec
              EOS
    bin.install "bin/eg"
  end

  test do
    system "#{bin}/eg"
  end
end
