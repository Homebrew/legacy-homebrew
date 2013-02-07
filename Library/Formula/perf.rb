require 'formula'
require 'tempfile'

class Perf < Formula
  homepage 'http://osmot.cs.cornell.edu/kddcup/software.html'
  url 'http://osmot.cs.cornell.edu/kddcup/perf/perf.src.tar.gz'
  sha1 '7fc1c8c94d05bbee06bc4dd6e00f1108d6334551'
  version '5.11'

  def install
    system "rm perf"
    system "make"
    bin.install "perf"
  end

  def test
    test_data = [[1, 0.80962],
                 [0, 0.48458],
                 [1, 0.65812],
                 [0, 0.16117],
                 [0, 0.47375],
                 [0, 0.26587],
                 [1, 0.71517],
                 [1, 0.63866],
                 [0, 0.36296],
                 [1, 0.89639],
                 [0, 0.35936],
                 [0, 0.22413],
                 [0, 0.36402],
                 [1, 0.41459],
                 [1, 0.83148],
                 [0, 0.23271]]

    input_file = Tempfile.new("perf_test")
    input_file.write(test_data.map{|x| x.join(" ")}.join("\n"))
    input_file.close

    output = `perf -ACC < #{input_file.path}`

    raise "Unable to execute perf" unless output == "ACC    0.93750   pred_thresh  0.500000\n"

  end
end
