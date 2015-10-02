class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.12.0/chapel-1.12.0.tar.gz"
  sha256 "d5ae943497566a5d87c4f56196d77e6051d0fdcea599fd86ab69732ed62456ae"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "364aabb29b63231fb16fd528232a60685fc6ee49358d0f8623eaccd6356d666e" => :yosemite
    sha256 "7b600c3db7fb0fcccaed605cf112bf6331930d9a1fb29cf9b522723b8db0e46c" => :mavericks
    sha256 "dd6605f94bad0dfbc342657d2dc43e037a482c2237c7f1c6aad3a1fa74df4236" => :mountain_lion
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://gist.github.com/DomT4/90dbcabcc15e5d4f786d
    # https://github.com/Homebrew/homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin/*"]
    bin.env_script_all_files libexec/"bin/darwin/", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    (testpath/"hello.chpl").write "writeln('Hello, world!');"
    system "#{bin}/chpl", "-o", "hello", "hello.chpl"
    assert_equal "Hello, world!", shell_output("./hello").strip
  end
end
