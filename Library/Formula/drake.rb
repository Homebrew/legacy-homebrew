require 'formula'

class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage 'https://github.com/Factual/drake'
  url 'https://github.com/Factual/drake/releases/download/v0.1.7/drake.jar'
  version '0.1.7'
  sha1 'c3092bd4e62effa38d4ade09bc191463b1c93c6a'

  def install
    libexec.install Dir['*']
    bin.write_jar_script libexec/'drake.jar', 'drake'
  end

  test do
    # count lines test
    (testpath/'Drakefile').write <<-EOS.undent
      find_lines <- [shell]
        echo 'drake' > $OUTPUT

      count_drakes_lines <- find_lines
        cat $INPUT | wc -l > $OUTPUT
    EOS

    # force run (no user prompt) the full workflow
    system bin/"drake", "--auto", "--workflow=#{testpath}/Drakefile", "+..."
  end
end
