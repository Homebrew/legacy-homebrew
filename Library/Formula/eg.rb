class Eg < Formula
  homepage "https://github.com/srsudar/eg"
  url "https://github.com/srsudar/eg/archive/v0.0.3.tar.gz"
  sha256 "c257e334f2a2e494f9b9791b92c1d3f7b00da3e2e7ec47f02d720342b466f968"

  def install
    if Dir.exist? "#{var}/examples"
      Dir["eg/examples/*"].each do |example|
        next if example.to_s == '.' || example.to_s == '..'
        mv example, "#{var}/examples/"
      end
      rmdir "eg/examples"
    else
      var.install "eg/examples"
    end

    inreplace "eg/eg_config.py",
              /DEFAULT_EXAMPLES_DIR = .+$/,
              "DEFAULT_EXAMPLES_DIR = os.path.join('#{var}', 'examples')"
    mv "eg", "commands"
    prefix.install "commands"
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
