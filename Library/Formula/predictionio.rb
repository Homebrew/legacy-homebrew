require 'formula'

class Predictionio < Formula
  homepage 'http://prediction.io/'
  url 'http://download.prediction.io/PredictionIO-0.7.3.zip'
  sha1 '5380f7f7d447ec04371753b060822e004c76a5fa'

  depends_on 'mongodb'
  depends_on 'hadoop'

  def install
    rm_f Dir["bin/*.bat"]

    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    mv "#{bin}/start-all.sh", "#{bin}/predictionio-start-all.sh"
    mv "#{bin}/stop-all.sh", "#{bin}/predictionio-stop-all.sh"
  end

  def caveats; <<-EOS.undent
    Before use, you must generate the database and create a user. Run:
      #{bin}/setup-vendors.sh
      #{bin}/setup.sh
      #{bin}/users

    After that, PredictionIO is ready.
    Start using:
      predictionio-start-all.sh
    Stop using:
      predictionio-stop-all.sh
    EOS
  end
end
