require 'formula'

class IosSim <Formula
  url 'http://cloud.github.com/downloads/Fingertips/ios-sim/ios-sim-1.0.zip'
  homepage 'https://github.com/Fingertips/ios-sim'
  md5 'd5aa0c959e2a9bc402657ae084819712'

  def install
    bin_dir = File.join(prefix, 'bin')
    system "mkdir -p #{bin_dir}"
    system "cp ios-sim #{bin_dir}"
  end
end
