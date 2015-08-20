class Bashtasklog < Formula
  desc "Bash library for beautiful logging to the console or a logfile."
  homepage "https://github.com/timbowhite/bashtasklog"
  url "https://github.com/timbowhite/bashtasklog/archive/0.1.0.tar.gz"
  sha256 "0d905e049adffbd2570579c203799f6402c0384d416b6558aa6cfd8c02672386"
  head "https://github.com/timbowhite/bashtasklog.git"

  keg_only "This formula is a library for use by other bash scripts."

  def install
    prefix.install Dir["*"]
  end

  def caveats
    <<-EOS.undent
      To use in your scripts:
        source $(brew --prefix bashtasklog)/bashtasklog.sh

      Example scripts:
        #{prefix}/examples/

      More Info:
        #{prefix}/README.md
    EOS
  end

  test do
    system "#{prefix}/examples/1.sh"
    system "#{prefix}/examples/2.sh"
    # Should be sufficient.
    # Skip examples 3 and 4; they use `sleep` multiple times.
  end
end
