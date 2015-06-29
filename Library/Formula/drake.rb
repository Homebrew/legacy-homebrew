require 'formula'

class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage 'https://github.com/Factual/drake'
  url 'https://raw.githubusercontent.com/Factual/drake/v1.0.0/bin/drake'
  version '1.0.0'
  sha1 '9a70c19e0cd80ba3f9c5a5df2c752c6a194af913'

  def install
    bin.install "drake"
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
