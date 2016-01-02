class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "http://chapel.cray.com/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.12.0/chapel-1.12.0.tar.gz"
  sha256 "d5ae943497566a5d87c4f56196d77e6051d0fdcea599fd86ab69732ed62456ae"
  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "d82ab96b382315f8797b79afaf689c54a4deae00493005b5b72effb5f7f977e6" => :el_capitan
    sha256 "050dafe7ce76513843f42a77ac2b3c3d0cb1f650fbb1539129f3581474fcac00" => :yosemite
    sha256 "7544469b3aa7bd1435e206e9c7a84e47def08a1ca970eaee628b193a875fea37" => :mavericks
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
