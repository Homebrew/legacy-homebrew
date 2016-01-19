class Vf < Formula
  desc "Enhanced version of `cd` command"
  homepage "https://github.com/glejeune/vf"
  url "https://github.com/glejeune/vf/archive/0.0.1.tar.gz"
  sha256 "6418d188b88d5f3885b7a8d24520ac47accadb5144ae24e836aafbea4bd41859"
  head "https://github.com/glejeune/vf.git"

  bottle :unneeded

  def install
    # Since the shell file is sourced instead of run
    # install to prefix instead of bin
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    To complete installation, add the following line to your shell's rc file:
      source #{prefix}/vf.sh
    EOS
  end

  test do
    (testpath/"test").mkpath
    assert_equal "cd test", shell_output("ruby #{prefix}/vf.rb test").chomp
  end
end
