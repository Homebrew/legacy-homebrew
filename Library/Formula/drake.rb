require 'formula'

class Drake < Formula
  homepage 'https://github.com/Factual/drake'
  url 'https://github.com/Factual/drake/releases/download/v0.1.6/drake.jar'
  version '0.1.6'
  sha1 '43870cf657a70fd484093f452ceab22fb4c33d3c'

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
