require 'formula'

class Agrep < Formula
  desc "Approximate GREP for fast fuzzy string searching."
  version "3.41.4"
  homepage "http://en.wikipedia.org/wiki/Agrep"
  url "https://github.com/timemachine3030/agrep.git", :using => :git, :tag => "osx/3.41.4"

  def install
    system "make", "CFLAGS=-D_OSX=1 #{ENV.cflags}"
    bin.install "agrep"
  end

  test do
      # check that it built correctly
      system bin/"agrep", "'' ."

      # quick searches
      (testpath/"Test.file").write <<-EOS.undent
        word
        wood
        wrod
      EOS
      assert_equal "2\nGrand Total: 2 match(es) found.", shell_output("#{bin}/agrep -1 -c word Test.file").strip
      assert_equal "3\nGrand Total: 3 match(es) found.", shell_output("#{bin}/agrep -2 -c word Test.file").strip

  end
end
