class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.07.tar.gz"
  sha1 "c40044a2747b97a2f8b550c1d417bb03848fcd40"

  def install
      bin.install "c"
  end

  test do
      system "c", "--help"

      File.open("test.c", "rw") do |f|
          f.write("#!/usr/bin/c blah blah blah")
      end
      system "sed". "-i.bak", "'1!b;s/^#!/\/\/#!/'", "test.c"
      File.open("test.c", "r") do |f|
          if f.readline != "//#!/usr/bin/c blah blah blah" then
              abort "error: sed is not compatible!"
          end
      end
  end
end
