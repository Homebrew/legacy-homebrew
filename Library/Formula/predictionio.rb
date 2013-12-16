require 'formula'

class Predictionio < Formula
  homepage 'http://prediction.io/'
  url 'http://download.prediction.io/PredictionIO-0.6.4.zip'
  sha1 '29422514f5f71eaa8bcf7e689083471f1ba93ca3'

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
      #{bin}/user

    After that, PredictionIO is ready.
    Start using:
      predictionio-start-all.sh
    Stop using:
      predictionio-stop-all.sh
    EOS
  end
end
