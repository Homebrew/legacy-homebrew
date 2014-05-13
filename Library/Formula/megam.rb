require "formula"

class Megam < Formula
  homepage "http://www.umiacs.umd.edu/~hal/megam/"
  url "http://hal3.name/megam/megam_src.tgz"
  sha1 "c9936d0504da70b774ba574c00fcfac48dcc366c"

  depends_on "objective-caml"

  def install
    ENV['WITHCLIBS'] = '-I /usr/local/lib/ocaml/caml'
    ENV['WITHSTR']   = 'str.cma -cclib -lcamlstr'
    # Build the non-optimized version
    system "make -e"
    bin.install "megam"
    system "make clean"
    # Build the optimized version
    system "make -e opt"
    bin.install "megam.opt"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test megam`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    File.open("tiny.megam", 'w') do |input|
      input.puts "0    F1 F2 F3"
      input.puts "1    F2 F3 F8"
      input.puts "0    F1 F2"
      input.puts "1    F8 F9 F10"
    end
    system "megam binary tiny.megam"
    system "megam.opt binary tiny.megam"
  end
end
