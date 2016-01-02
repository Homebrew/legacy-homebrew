class Brotli < Formula
  desc "Ggeneric-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "634d1089ee21b35e0ec5066cb5e44dd097e04e679e1e8c50bffa2b0dc77c2c29"

  head "https://github.com/google/brotli"

  depends_on :python if MacOS.version <= :snow_leopard
  conflicts_with "bro", :because => "Both install a `bro` binary"

  def install
    system "make", "-C", "tools"
    bin.install "tools/bro" => "bro"
  end

  test do
    (testpath/"file.txt").write <<-EOS.undent
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas imperdiet felis ut laoreet auctor. Quisque viverra ipsum quis purus varius, quis ornare nulla ullamcorper. Sed tincidunt dolor ac mi eleifend, eget tincidunt sapien accumsan. Proin condimentum vehicula nunc sit amet accumsan. Phasellus dolor ipsum, semper non diam eget, condimentum euismod lacus. Ut tristique diam eu mi dictum, quis viverra lectus hendrerit. Nulla et tortor nec sapien laoreet porttitor fringilla ut ex. Morbi eros sapien, sollicitudin vel sem vitae, lacinia blandit purus. Praesent id purus a tellus sollicitudin scelerisque in in ligula. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus ante diam, sollicitudin at urna at, tincidunt feugiat augue. Suspendisse semper magna laoreet mi interdum rhoncus. Nunc et tellus lectus.

      Nunc finibus vitae justo quis ultricies. Pellentesque semper rutrum urna, aliquet facilisis lorem hendrerit eu. Nullam facilisis interdum tortor molestie imperdiet. Maecenas fermentum tempor neque, ac bibendum velit lobortis non. Integer ut sapien nulla. Morbi molestie lacus tellus, sit amet ornare ipsum malesuada eu. Donec mattis erat elit, quis viverra libero tempus semper. In venenatis odio metus, vel mollis leo luctus in.
    EOS
    system "#{bin}/bro", "--input", "file.txt", "--output", "file.txt.br"
    system "#{bin}/bro", "--input", "file.txt.br", "--output", "out.txt", "--decompress"
    assert_equal shell_output("cat file.txt"), shell_output("cat out.txt")
  end
end
