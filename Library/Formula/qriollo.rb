class Qriollo < Formula
  desc "Impure functional language, based on Rioplatense Spanish."
  homepage "https://qriollo.github.io"
  url "https://qriollo.github.io/Qriollo-0.91.tar.gz"
  sha256 "c8357af8254a082d8e4da1de1bbf13bee27cfde8adb31ea0a5a0966bfbb7b28d"
  head "https://github.com/qriollo/qriollo.git"

  bottle do
    sha256 "c570641b476c08b7e8d26ea37486f6db64cb6f573e0228b3893742857ceca7a0" => :el_capitan
    sha256 "dab13bc1d92169631801eaa347f58a71049a762b3994ace1efbbcb813a72afb3" => :yosemite
    sha256 "bc0ef3114f072bfcbf3b647f47d77f82e24f650b52edfbd1b3f34fd4dcc08c98" => :mavericks
  end

  depends_on "ghc" => :build

  def install
    system "make"
    bin.install "qr"
    (lib/"chamuyo").install "Chamuyo.q"
  end

  def caveats
    <<-EOS.undent
      The standard module "Chamuyo.q" has been placed in:
        #{lib}/chamuyo
    EOS
  end

  test do
    test_file_name = "HolaMundo.q"
    (testpath/test_file_name).write <<-EOS.undent
      enchufar Chamuyo
      el programa es
         escupir "Hola mundo\n"
    EOS
    system bin/"qr", "--ruta", "#{lib/"chamuyo"}:#{testpath}", test_file_name
  end
end
